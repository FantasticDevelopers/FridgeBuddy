//
//  CaptureItemPhotoViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-06.
//  Modified by Inderdeep on 2022-09-25.
//

import SwiftUI




@MainActor final class CaptureItemPhotoViewModel : ObservableObject {
    @Published var cameraService = CameraService()
    @Published var cameraBarcodeService = CameraBarcodeService()
    @Published var showCamera : Bool = true
    @Published var alertItem = AlertItemView()
    @Published var capturedImage : UIImage?
    @Published var upc: String = "06680000015"
    @Published var barcodeItem : BarCodeItem = BarCodeItem()
    
    enum GetDataError: Error {
        case invalidURL
        case missingData
    }
    
    func cropImage(data: Data) {
        let originalImage = UIImage(data: data)
        if let originalImage = originalImage {
            let outputRect = cameraService.previewlayer.metadataOutputRectConverted(fromLayerRect: cameraService.previewlayer.bounds)
            var cgImage = originalImage.cgImage!
            let width = CGFloat(cgImage.width)
            let height = CGFloat(cgImage.height)
            let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)
            
            cgImage = cgImage.cropping(to: cropRect)!
            let croppedUIImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: originalImage.imageOrientation)
            self.capturedImage = croppedUIImage
            cameraService.stopSession()
            withAnimation {
                showCamera.toggle()
            }
        } else {
            alertItem.show(title: "Please try again!", message: "Image not found.", buttonTitle: "Got it!")
        }
    }
    
    // creates the GET call to Food API to receive information of food item scanned
    func getData() async{
        let app_id = "c2408257"  // x-app-id
        let app_key = "4ae9aefb7857e01bfb620a9890ce284d"    //x-app-key
        guard let url = URL(string: "https://trackapi.nutritionix.com/v2/search/item?upc=" + self.upc) else{
            fatalError("Fatal Error")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(app_id, forHTTPHeaderField: "x-app-id")
        request.setValue(app_key, forHTTPHeaderField: "x-app-key")
        URLSession.shared.dataTask(with: request){ data, response , error in
            guard let data = data else{return}
            do{
                let decodedData = try JSONDecoder().decode(Results.self, from: data)
                print("json done")
                DispatchQueue.main.async {
                    self.barcodeItem = BarCodeItem(f_name: decodedData.foods?.first?.food_name ?? "", b_name: decodedData.foods?.first?.brand_name ?? "", nix_b_name: decodedData.foods?.first?.nix_brand_name ?? "", nix_b_id: decodedData.foods?.first?.nix_brand_id ?? "", nix_i_name: decodedData.foods?.first?.nix_item_name ?? "", nix_i_id: decodedData.foods?.first?.nix_item_id ?? "")
                }
            }catch let error{
                print(error)
            }
        }.resume()
    }
}

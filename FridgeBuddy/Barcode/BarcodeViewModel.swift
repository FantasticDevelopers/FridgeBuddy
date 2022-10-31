//
//  BarcodeViewModel.swift
//  FridgeBuddy
//
//  Created by Inderdeep on 2022-10-25.
//

import SwiftUI

@MainActor final class BarcodeViewModel : ObservableObject {
    @Published var cameraBarcodeService = CameraBarcodeService()
    @Published var showCamera : Bool = true
    @Published var showAddForm : Bool = false
    @Published var alertItem = AlertItemView()
    @Published var upc: String = ""
    
    func getData(completion: @escaping (Result<BarCodeItem, Error>) -> Void) {
        let app_id = "9ab2e84d"  // x-app-id
        let app_key = "394fa6fe4ee131d96db3f3015c8ffe5d"    //x-app-key
        guard let url = URL(string: "https://trackapi.nutritionix.com/v2/search/item?upc=" + self.upc) else{
            fatalError("Fatal Error")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(app_id, forHTTPHeaderField: "x-app-id")
        request.setValue(app_key, forHTTPHeaderField: "x-app-key")
        URLSession.shared.dataTask(with: request){ data, response , error in
            guard let data = data else { return }
            do{
                let decodedData = try JSONDecoder().decode(Results.self, from: data)
                let barcodeItem = BarCodeItem(f_name: decodedData.foods?.first?.food_name ?? "", b_name: decodedData.foods?.first?.brand_name ?? "", nix_b_name: decodedData.foods?.first?.nix_brand_name ?? "", nix_b_id: decodedData.foods?.first?.nix_brand_id ?? "", nix_i_name: decodedData.foods?.first?.nix_item_name ?? "", nix_i_id: decodedData.foods?.first?.nix_item_id ?? "")
                completion(.success(barcodeItem))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func checkGlobalDatabase(items : [Item]) -> Item? {
        return items.filter { $0.upc == upc }.first
    }
}

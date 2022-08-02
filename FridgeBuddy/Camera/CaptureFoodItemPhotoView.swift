//
//  CaptureFoodItemPhotoView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-01.
//

import SwiftUI

struct CaptureFoodItemPhotoView : View {
    let cameraService = CameraService()
    @Binding var capturedImage: UIImage?
    @State var alertItem = AlertItemView()
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            CameraView(cameraService: cameraService) { result in
                switch result {
                case .success(let photo):
                    if let data = photo.fileDataRepresentation() {
                        capturedImage = UIImage(data: data)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        alertItem.title = Text("Please try again!")
                        alertItem.message = Text("Image not found.")
                        alertItem.buttonTitle = "Got it!"
                        alertItem.showAlert = true
                    }
                case .failure(let error):
                    alertItem.title = Text("Please try again!")
                    alertItem.message = Text("\(error.localizedDescription)")
                    alertItem.buttonTitle = "Got it!"
                    alertItem.showAlert = true
                }
            }
            
            VStack {
                Spacer()
                Text("Capture the photo of food item")
                    .padding(.bottom)
                Button {
                    cameraService.capturePhoto()
                } label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundColor(Color.white)
                }
                .padding(.bottom)
            }
        }
        .alert(alertItem.title, isPresented: $alertItem.showAlert) {
            Button(alertItem.buttonTitle) {}
        } message: {
            alertItem.message
        }
    }
}

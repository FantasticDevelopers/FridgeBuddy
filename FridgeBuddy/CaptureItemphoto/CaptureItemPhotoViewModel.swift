//
//  CaptureItemPhotoViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-06.
//

import SwiftUI

@MainActor final class CaptureItemPhotoViewModel : ObservableObject {
    @Published var cameraService = CameraService()
    @Published var showCamera : Bool = true
    @Published var alertItem = AlertItemView()
    @Published var capturedImage : UIImage?
    
    func cropImage(data: Data) {
        let originalImage = UIImage(data: data)
        if let originalImage = originalImage {
            let cgImage = originalImage.cgImage
            if let cgImage = cgImage {
                let outputRect = cameraService.previewlayer.metadataOutputRectConverted(fromLayerRect: cameraService.previewlayer.bounds)
                let width = CGFloat(cgImage.width)
                let height = CGFloat(cgImage.height)
                let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)
                
                let croppedCgImage = cgImage.cropping(to: cropRect)
                if let croppedCgImage = croppedCgImage {
                    let croppedUIImage = UIImage(cgImage: croppedCgImage, scale: 1.0, orientation: originalImage.imageOrientation)
                    self.capturedImage = croppedUIImage
                    cameraService.stopSession()
                    withAnimation {
                        showCamera.toggle()
                    }
                    return
                }
            }
        }
        alertItem.show(title: "Please try again!", message: "Image not found.", buttonTitle: "Got it!")
    }
}

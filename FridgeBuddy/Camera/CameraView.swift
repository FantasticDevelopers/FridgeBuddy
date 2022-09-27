//
//  CameraView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-01.
//  Modified by Inderdeep on 2022-09-20.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    let cameraService : CameraService
    let didFinishProcessingPhoto : (Result<AVCapturePhoto, Error>) -> ()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        cameraService.start(delegate: context.coordinator) { error in
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
        }
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewlayer)
        cameraService.previewlayer.frame = viewController.view.bounds
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    class Coordinator : NSObject, AVCapturePhotoCaptureDelegate {
        let parent : CameraView
        private var didFinishProcessingPhoto : (Result<AVCapturePhoto, Error>) -> ()
        
        init(_ parent :  CameraView, didFinishProcessingPhoto : @escaping (Result<AVCapturePhoto, Error>) -> ()) {
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
            didFinishProcessingPhoto(.success(photo))
        }
    }
}

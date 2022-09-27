//
//  CameraBarcodeView.swift
//  FridgeBuddy
//
//  Created by Inderdeep on 2022-09-25.
//

import SwiftUI
import AVFoundation

struct CameraBarcodeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    //define the camera service reference
    let cameraBarcodeService : CameraBarcodeService
    //define the Metadata Processing func
    let didfinishProcessingMetadata : (Result<String, Error>) -> ()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, didfinishProcessingMetadata: didfinishProcessingMetadata)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        cameraBarcodeService.start(delegate: context.coordinator) { error in
            if let error = error {
                didfinishProcessingMetadata(.failure(error))
                return
            }
        }
        
        // preview layer bounds
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        cameraBarcodeService.previewlayer.frame = CGRect(x: viewController.view.bounds.minX, y: viewController.view.bounds.minY + viewController.view.bounds.maxY / 4, width: viewController.view.bounds.width, height: viewController.view.bounds.height / 3)
        cameraBarcodeService.previewlayer.frame = cameraBarcodeService.previewlayer.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        cameraBarcodeService.previewlayer.cornerRadius = 10
        viewController.view.layer.addSublayer(cameraBarcodeService.previewlayer)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    
    class Coordinator : NSObject , AVCaptureMetadataOutputObjectsDelegate {
        let parent : CameraBarcodeView
        private var didfinishProcessingMetadata : (Result<String, Error>) -> ()
        
        init(_ parent :  CameraBarcodeView, didfinishProcessingMetadata : @escaping (Result<String, Error>) -> ()) {
            self.parent = parent
            self.didfinishProcessingMetadata = didfinishProcessingMetadata
        }
        
        // get the metadata from the connection Output and create a Machine Readable Object
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                parent.cameraBarcodeService.stopSession()
                found(code: stringValue)
                didfinishProcessingMetadata(.success(stringValue))
            }
            else{
                didfinishProcessingMetadata(.failure(NSCoderValueNotFoundError as! Error))
            }
        }
        
        func found(code: String) {
                print(code)
            }
    }
    
}

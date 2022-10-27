//
//  CameraBarcodeService.swift
//  FridgeBuddy
//
//  Created by Inderdeep on 2022-09-25.
//

import Foundation
import AVFoundation

class CameraBarcodeService {
    
    var session = AVCaptureSession()
    var delegate : AVCaptureMetadataOutputObjectsDelegate?
    
    let output = AVCaptureMetadataOutput()
    let previewlayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate : AVCaptureMetadataOutputObjectsDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    private func checkPermissions(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        do {
            session.beginConfiguration()
            if let device = AVCaptureDevice.default(for: .video) {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                    
                    output.setMetadataObjectsDelegate(delegate!, queue: DispatchQueue.main)
                    output.metadataObjectTypes = [ .upce , .ean13 , .ean8]
                }
                
                session.commitConfiguration()
                
                previewlayer.videoGravity = .resizeAspectFill
                previewlayer.session = session
                
                startSession()
            }
        } catch {
            completion(error)
        }
    }
    
    func startSession() {
        if !session.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }
}

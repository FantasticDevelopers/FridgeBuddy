//
//  CameraService.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-01.
//  Modified by Inderdeep on 2022-09-20.
//

import Foundation
import AVFoundation

class CameraService {
    
    var session = AVCaptureSession()
    var delegate : AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewlayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate : AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
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
    
    func capturePhoto(with settings : AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }
}

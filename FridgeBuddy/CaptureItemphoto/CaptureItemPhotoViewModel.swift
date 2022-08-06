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
}

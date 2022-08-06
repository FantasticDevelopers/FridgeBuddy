//
//  CaptureItemPhotoView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-01.
//

import SwiftUI

struct CaptureItemPhotoView : View {
    let cameraService = CameraService()
    
    @Binding var capturedImage: UIImage?
    @Binding var showForm : Bool
    
    @State var showCamera : Bool = true
    @State var alertItem = AlertItemView()
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        if showCamera {
            ZStack {
                CameraView(cameraService: cameraService) { result in
                    switch result {
                    case .success(let photo):
                        if let data = photo.fileDataRepresentation() {
                            capturedImage = UIImage(data: data)
                            cameraService.stopSession()
                            showCamera.toggle()
                        } else {
                            alertItem.show(title: "Please try again!", message: "Image not found.", buttonTitle: "Got it!")
                        }
                    case .failure(let error):
                        alertItem.show(title: "Please try again!", message: error.localizedDescription, buttonTitle: "Got it!")
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
        } else {
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                         Image(systemName: "arrowshape.turn.up.backward.fill")
                            .resizable()
                            .frame(width: 40, height: 20)
                            .padding(.leading)
                            .padding(.top)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                Image(uiImage: capturedImage!)
                    .resizable()
                    .frame(width: 350, height: 300)
                
                Spacer()
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        showForm.toggle()
                    } label: {
                        ButtonView(buttonText: "Add Item", width: 150, symbol: "plus.circle.fill")
                            .padding(.leading)
                    }
                    
                    Spacer()
                   
                    Button {
                        cameraService.startSession()
                        showCamera.toggle()
                    } label: {
                        ButtonView(buttonText: "Recapture", width: 150, symbol: "camera.circle.fill")
                            .padding(.trailing)
                    }
                }
            }
        }
    }
}

struct CaptureItemPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureItemPhotoView(capturedImage: .constant(UIImage(imageLiteralResourceName: "LoginIcon")), showForm: .constant(false), showCamera: false)
    }
}


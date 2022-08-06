//
//  CaptureItemPhotoView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-01.
//

import SwiftUI

struct CaptureItemPhotoView : View {
    @StateObject var captureItemPhotoViewModel = CaptureItemPhotoViewModel()
    
    @Binding var capturedImage: UIImage?
    @Binding var showForm : Bool
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        if captureItemPhotoViewModel.showCamera {
            ZStack {
                CameraView(cameraService: captureItemPhotoViewModel.cameraService) { result in
                    switch result {
                    case .success(let photo):
                        if let data = photo.fileDataRepresentation() {
                            capturedImage = UIImage(data: data)
                            captureItemPhotoViewModel.cameraService.stopSession()
                            withAnimation {
                                captureItemPhotoViewModel.showCamera.toggle()
                            }
                        } else {
                            captureItemPhotoViewModel.alertItem.show(title: "Please try again!", message: "Image not found.", buttonTitle: "Got it!")
                        }
                    case .failure(let error):
                        captureItemPhotoViewModel.alertItem.show(title: "Please try again!", message: error.localizedDescription, buttonTitle: "Got it!")
                    }
                }
                
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
                    Text("Capture the photo of food item")
                        .padding(.bottom)
                    Button {
                        captureItemPhotoViewModel.cameraService.capturePhoto()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 65, height: 65)
                            
                            Circle()
                                .stroke(Color.green, lineWidth: 2)
                                .frame(width: 75, height: 75)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .alert(captureItemPhotoViewModel.alertItem.title, isPresented: $captureItemPhotoViewModel.alertItem.showAlert) {
                Button(captureItemPhotoViewModel.alertItem.buttonTitle) {}
            } message: {
                captureItemPhotoViewModel.alertItem.message
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
                    .frame(width: 300, height: 300)
                
                Spacer()
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        withAnimation {
                            showForm.toggle()
                        }
                    } label: {
                        ButtonView(buttonText: "Add Item", width: 150, symbol: "plus.circle.fill")
                            .padding(.leading)
                    }
                    
                    Spacer()
                   
                    Button {
                        DispatchQueue.global(qos: .background).async {
                            captureItemPhotoViewModel.cameraService.startSession()
                            DispatchQueue.main.async {
                                withAnimation {
                                    captureItemPhotoViewModel.showCamera.toggle()
                                }
                            }
                        }
                    } label: {
                        ButtonView(buttonText: "Retake", width: 150, symbol: "camera.circle.fill")
                            .padding(.trailing)
                    }
                }
            }
        }
    }
}

struct CaptureItemPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureItemPhotoView(capturedImage: .constant(UIImage(imageLiteralResourceName: "LoginIcon")), showForm: .constant(false))
    }
}


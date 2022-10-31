//
//  CaptureItemPhotoView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-01.
//
import SwiftUI

struct CaptureItemPhotoView : View {
    @StateObject var captureItemPhotoViewModel = CaptureItemPhotoViewModel()
    @EnvironmentObject var addFormViewModel : AddFormViewModel
    @EnvironmentObject var addViewModel : AddViewModel
        
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        if captureItemPhotoViewModel.showCamera {
            ZStack {
                CameraView(cameraService: captureItemPhotoViewModel.cameraService) { result in
                    switch result {
                    case .success(let photo):
                        if let data = photo.fileDataRepresentation() {
                            captureItemPhotoViewModel.cropImage(data: data)
                        } else {
                            captureItemPhotoViewModel.alertItem.show(title: "Please try again!", message: "Image not found.", buttonTitle: "Got it!")
                        }
                    case .failure(let error):
                        captureItemPhotoViewModel.alertItem.show(title: "Please try again!", message: error.localizedDescription, buttonTitle: "Got it!")
                    }
                }
                .ignoresSafeArea(.all)
                
                VStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            if addFormViewModel.item.isBarcodeItem {
                                addViewModel.showBarcode.toggle()
                            }
                            captureItemPhotoViewModel.cameraService.stopSession()
                        } label: {
                             Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.leading)
                                .padding(.top)
                        }

                        Spacer()
                    }
                    
                    Spacer()
                    Text("Capture the photo of food item")
                        .foregroundColor(.accentColor)
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
            NavigationView {
                VStack {
                    Text("Public Photo")
                    
                    Spacer()
                    
                    Image(uiImage: captureItemPhotoViewModel.capturedImage!)
                        .resizable()
                        .cornerRadius(10)
                        .frame(width: captureItemPhotoViewModel.cameraService.previewlayer.frame.width, height: captureItemPhotoViewModel.cameraService.previewlayer.frame.height)
                    
                    Spacer()
                    Spacer()
                    
                    HStack {
                        Button {
                            if addFormViewModel.item.name.isEmpty || addFormViewModel.item.brand.isEmpty {
                                addFormViewModel.item.image = captureItemPhotoViewModel.capturedImage
                                captureItemPhotoViewModel.addItem.toggle()
                            } else {
                                addViewModel.showBarcode.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    addViewModel.item = addFormViewModel.item
                                    addViewModel.item.image = captureItemPhotoViewModel.capturedImage
                                    addViewModel.isAddingItem.toggle()
                                }
                            }
                        } label: {
                            ButtonView(buttonText: "Add Item", width: 150, symbol: "plus.circle.fill")
                                .padding(.leading)
                        }
                        
                        NavigationLink(destination: AddFormView(), isActive: $captureItemPhotoViewModel.addItem) {
                            EmptyView()
                        }
                        
                        Spacer()
                       
                        Button {
                            captureItemPhotoViewModel.cameraService.startSession()
                            DispatchQueue.main.async {
                                withAnimation {
                                    captureItemPhotoViewModel.showCamera.toggle()
                                }
                            }
                        } label: {
                            ButtonView(buttonText: "Retake", width: 150, symbol: "camera.circle.fill")
                                .padding(.trailing)
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            if addFormViewModel.item.isBarcodeItem {
                                addViewModel.showBarcode.toggle()
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundColor(Color.green)
                        }
                        
                    }
                }
            }
        }
    }
}

struct CaptureItemPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureItemPhotoView()
    }
}

//
//  BarcodeView.swift
//  FridgeBuddy
//
//  Created by Inderdeep on 2022-10-25.
//

import SwiftUI

struct BarcodeView: View {
    @StateObject var barcodeViewModel = BarcodeViewModel()
    @EnvironmentObject var itemViewModel : ItemsViewModel
    @EnvironmentObject var addViewModel : AddViewModel
    @EnvironmentObject var addFormViewModel : AddFormViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            if barcodeViewModel.showCamera {
                ZStack {
                    CameraBarcodeView(cameraBarcodeService: barcodeViewModel.cameraBarcodeService){ result in
                        switch result{
                        case .success(let barcode):
                            barcodeViewModel.upc = barcode
                            if let item = barcodeViewModel.checkGlobalDatabase(items: itemViewModel.items) {
                                addViewModel.showBarcode.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    addViewModel.item = item
                                    addViewModel.isAddingItem.toggle()
                                }
                            } else {
                                addFormViewModel.item.upc = barcodeViewModel.upc
                                addFormViewModel.item.isBarcodeItem = true
                                barcodeViewModel.getData { result in
                                    switch result {
                                    case .success(let barcodeItem):
                                        DispatchQueue.main.async {
                                            barcodeViewModel.barcodeItem = barcodeItem
                                            addFormViewModel.item.name = barcodeViewModel.barcodeItem.nix_item_name
                                            addFormViewModel.item.brand = barcodeViewModel.barcodeItem.nix_brand_name
                                            barcodeViewModel.showCamera.toggle()
                                            barcodeViewModel.showAddForm.toggle()
                                        }
                                    case .failure(let error):
                                        barcodeViewModel.alertItem.show(title: "Please try again!", message: error.localizedDescription, buttonTitle: "Got it!")
                                    }
                                }
                            }
                        case .failure(let error):
                            barcodeViewModel.alertItem.show(title: "Please try again!", message: error.localizedDescription, buttonTitle: "Got it!")
                        }
                    }
                    .ignoresSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                barcodeViewModel.cameraBarcodeService.stopSession()
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
                        
                        Text("Scan the bar code of food item")
                            .foregroundColor(.accentColor)
                            .padding(.bottom)
                    }
                }
                .alert(barcodeViewModel.alertItem.title, isPresented: $barcodeViewModel.alertItem.showAlert) {
                    Button(barcodeViewModel.alertItem.buttonTitle) {}
                } message: {
                    barcodeViewModel.alertItem.message
                }
               
            }
            else {
                NavigationLink(isActive: $barcodeViewModel.showAddForm) {
                    CaptureItemPhotoView()
                        .navigationBarBackButtonHidden()
                } label: {
                    EmptyView()
                }
            }
        }
    }
}

struct BarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeView()
    }
}

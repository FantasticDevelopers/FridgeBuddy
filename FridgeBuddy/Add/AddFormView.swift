//
//  AddFormView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-02.
//

import SwiftUI

struct AddFormView: View {
    @EnvironmentObject var addFormViewModel : AddFormViewModel
    @EnvironmentObject var addViewModel : AddViewModel
    @EnvironmentObject var itemsViewModel : ItemsViewModel
    
    @Environment(\.presentationMode) private var presentationMode
        
    var body: some View {
        ScrollView {
            VStack {
                Text("Add Item")
                    .foregroundColor(Color.green)
                    .font(.largeTitle)
                
                if let image = addFormViewModel.item.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding(.bottom)
                } else {
                    Image("NoImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding(.bottom)
                }
                
                Group {
                    TextFieldView(text: "Name", value: $addFormViewModel.item.name)
                    
                    TextFieldView(text: "Brand", value: $addFormViewModel.item.brand)
                    
                    Stepper("Quantity: \(addFormViewModel.quantity)", value: $addFormViewModel.quantity, in: 1...1000)
                        .padding(.vertical, 5.0)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 4)
                            .stroke( Color.black.opacity(0.7), lineWidth: 2))
                        .padding(.bottom)
                    
                    DatePicker("Expiry Date", selection: $addFormViewModel.expiryDate, displayedComponents: .date)
                        .padding(.vertical, 5.0)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 4)
                            .stroke( Color.black.opacity(0.7), lineWidth: 2))
                        .padding(.bottom)
                }
                
                Button {
                    addFormViewModel.addNonBarcodeItem { (result) in
                        switch result {
                        case .success(let items):
                            addViewModel.items.append(items[0])
                            itemsViewModel.items.append(items[1])
                        case .failure(let error):
                            addFormViewModel.alertItem.show(title: "Please try again!", message: error.localizedDescription, buttonTitle: "Got it!")
                        }
                    }
                    if addFormViewModel.item.isBarcodeItem {
                        addViewModel.showBarcode.toggle()
                    } else {
                        addViewModel.showCamera.toggle()
                    }
                } label: {
                    ButtonView(buttonText: "Add Item", symbol: "plus.circle.fill")
                }
                
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .foregroundColor(Color.green)
                    }
                }
            }
            .alert(addFormViewModel.alertItem.title, isPresented: $addFormViewModel.alertItem.showAlert) {
                Button(addFormViewModel.alertItem.buttonTitle) {}
            } message: {
                addFormViewModel.alertItem.message
            }
        }
    }
}

struct AddFormView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddFormView()
    }
}

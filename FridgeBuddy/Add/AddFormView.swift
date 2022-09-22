//
//  AddFormView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-02.
//

import SwiftUI

struct AddFormView: View {
    @StateObject var addFormViewModel = AddFormViewModel()
    @ObservedObject var addViewModel : AddViewModel
    @EnvironmentObject var launchViewModel : LaunchViewModel
    
    var capturedPhoto : UIImage
    
    @Environment(\.presentationMode) private var presentationMode
        
    var body: some View {
        VStack {
            Text("Add Item")
                .foregroundColor(Color.green)
                .font(.largeTitle)
            
            Image(uiImage: capturedPhoto)
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(10)
                .padding(.bottom)
            
            Group {
                TextFieldView(text: "Name", value: $addFormViewModel.item.name)
                
                TextFieldView(text: "Brand", value: $addFormViewModel.item.brand)
                
                TextFieldView(text: "Category", value: $addFormViewModel.item.category)
                
                DatePicker("Expiry Date", selection: $addFormViewModel.expiryDate, in: Date()..., displayedComponents: .date)
                    .padding(.vertical, 5.0)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4)
                        .stroke( Color.black.opacity(0.7), lineWidth: 2))
                    .padding(.bottom)
                
                Stepper("Quantity: \(addFormViewModel.quantity)", value: $addFormViewModel.quantity, in: 1...1000)
                    .padding(.vertical, 5.0)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4)
                        .stroke( Color.black.opacity(0.7), lineWidth: 2))
                    .padding(.bottom)
            }
            
            Button {
                addFormViewModel.item.image = capturedPhoto
                addFormViewModel.addNonBarcodeItem { item in
                    if let item = item {
                        launchViewModel.items.append(item)
                    }
                }
                addViewModel.showCamera.toggle()
            } label: {
                ButtonView(buttonText: "Add Item", symbol: "plus.circle.fill")
            }
            
            Spacer()
        }
        .padding()
        .offset(y: -60)
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

struct AddFormView_Previews: PreviewProvider {
   static var capturedPhoto : UIImage = UIImage(imageLiteralResourceName: "LoginIcon")
    
    static var previews: some View {
        AddFormView(addViewModel: AddViewModel(), capturedPhoto: capturedPhoto)
    }
}

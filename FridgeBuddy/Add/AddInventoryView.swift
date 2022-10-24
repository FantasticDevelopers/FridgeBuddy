//
//  AddInventoryView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-09-28.
//

import SwiftUI

struct AddInventoryView: View {
    var item : Item
    @StateObject var addInventoryViewModel = AddInventoryViewModel()
    @EnvironmentObject var itemsViewModel : ItemsViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            HStack{
                if let image = item.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .cornerRadius(10)
                } else {
                    Image("NoImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .cornerRadius(10)
                }
                    
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)

                    Text(item.category.value)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Stepper("Quantity: \(addInventoryViewModel.quantity)", value: $addInventoryViewModel.quantity, in: 1...1000)
                .padding(.vertical, 5.0)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 4)
                    .stroke( Color.black.opacity(0.7), lineWidth: 2))
                .padding(.bottom)
            
            DatePicker("Expiry Date", selection: $addInventoryViewModel.expiryDate, displayedComponents: .date)
                .padding(.vertical, 5.0)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 4)
                    .stroke( Color.black.opacity(0.7), lineWidth: 2))
                .padding(.bottom)
            
            Spacer()
            
            Button {
                addInventoryViewModel.addToInventory(item: item) { (result) in
                    switch result {
                    case .success(let item):
                        itemsViewModel.items.append(item)
                        itemsViewModel.setSections()
                    case .failure(let error):
                        addInventoryViewModel.alertItem.show(title: "Please try again!", message: error.localizedDescription, buttonTitle: "Got it!")
                    }
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                ButtonView(buttonText: "Add to inventory")
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            addInventoryViewModel.expiryDate = Calendar.current.date(byAdding: .day, value: item.expiryDays!, to: Date())!
        }
    }
}

struct AddInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddInventoryView(item: Item())
    }
}

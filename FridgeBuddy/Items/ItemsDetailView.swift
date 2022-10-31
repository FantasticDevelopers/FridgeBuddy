//
//  ItemsDetailView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-10-15.
//

import SwiftUI

struct ItemsDetailView: View {
    var item : Item
    @State var state : FoodState = .fresh
    @EnvironmentObject var itemsViewModel : ItemsViewModel
    @StateObject var itemsDetailViewModel = ItemsDetailViewModel()
    
    var body: some View {
        VStack {
            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(height: 200)
            } else {
                Image("NoImage")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(height: 200)
            }
            
            Text(item.name)
                .font(.largeTitle)
                .padding(.bottom, 2)
            
            Text("Brand: \(item.brand.isEmpty ? "No Brand" : item.brand)")
                .padding(.bottom, 2)
            
            Text("Quantity: \(item.quantity!)")
                .padding(.bottom, 2)
            
            Text("Expiry: \(itemsViewModel.formatDate(date: item.expiryDate!))")
                .padding(.bottom, 2)
            
            HStack {
                Text("Change State")
                
                Spacer()
                
                Picker(selection: $state.onChange {
                    item.state = state
                    itemsDetailViewModel.changeItemState(item: item) {
                        if let index = itemsViewModel.items.firstIndex(where: {$0.id == item.id}) {
                            itemsViewModel.items[index].state = item.state
                            itemsViewModel.showDetails.toggle()
                        }
                    }
                }) {
                    ForEach(FoodState.allCases, id: \.self) { state in
                        Text(state.value)
                    }
                } label: {
                    Text("Change State")
                }
            }
            .padding(.vertical, 5.0)
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 4)
                .stroke( Color.black.opacity(0.7), lineWidth: 2))
            .padding()
            
            Button {
                itemsDetailViewModel.deleteItem(item: item) {
                    itemsViewModel.items.removeAll { item in
                        return item.id == self.item.id
                    }
                    itemsViewModel.showDetails.toggle()
                }
            } label: {
                ButtonView(buttonText: "Delete Item", symbol: "minus.circle")
            }

        }
        .onAppear {
            state = item.state!
        }
        .alert(itemsDetailViewModel.alertItem.title, isPresented: $itemsDetailViewModel.alertItem.showAlert) {
            Button(itemsDetailViewModel.alertItem.buttonTitle) {}
        } message: {
            itemsDetailViewModel.alertItem.message
        }
    }
}

struct ItemsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsDetailView(item: Item())
    }
}

//
//  ItemsView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

struct ItemsView: View {
    @EnvironmentObject var itemsViewModel : ItemsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $itemsViewModel.selectedState) {
                    ForEach(FoodState.allCases, id: \.self) { state in
                        Text(state.value)
                    }
                } label: {
                    Text("State")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top)
                
                ScrollView(.vertical, showsIndicators: false) {
                    let gridItem = GridItem(.fixed(190))
                    LazyVGrid(columns: [gridItem, gridItem], alignment: .center) {
                        ForEach(itemsViewModel.filteredItems) { item in
                            ItemCard(item: item)
                        }
                    }
                }
            }
            .searchable(text: $itemsViewModel.searchText, prompt: "Search for an item")
            .navigationTitle("Your Items")
        }
        .sheet(isPresented: $itemsViewModel.showDetails) {
            if #available(iOS 16.0, *) {
                ItemsDetailView(item: itemsViewModel.item)
                    .presentationDetents([.fraction(0.75)])
            } else {
                ItemsDetailView(item: itemsViewModel.item)
            }
        }
        .alert(itemsViewModel.alertItem.title, isPresented: $itemsViewModel.alertItem.showAlert) {
            Button(itemsViewModel.alertItem.buttonTitle) {}
        } message: {
            itemsViewModel.alertItem.message
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}

struct ItemCard : View {
    @EnvironmentObject var itemsViewModel : ItemsViewModel
    var item : Item
    
    var body: some View {
        VStack {
            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(height: 120)
            } else {
                Image("NoImage")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(height: 120)
            }
            
            
            Text(item.name)
                .lineLimit(1)
            
            Text("Quantity: \(item.quantity!)")
            
            Text("Expiry: \(itemsViewModel.formatDate(date: item.expiryDate!))")
        }
        .padding()
        .background(.red.opacity(0.3))
        .cornerRadius(10)
        .onTapGesture {
            itemsViewModel.item = item
            itemsViewModel.showDetails.toggle()
        }
    }
}

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
                Picker(selection: $itemsViewModel.selectedState.onChange {
                    itemsViewModel.setSections()
                }) {
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
                        ForEach(Categories.allCases, id: \.self) { category in
                            switch category {
                            case .vegetables:
                                if itemsViewModel.vegetablesSection {
                                    ItemSection(category: category)
                                }
                            case .fruits:
                                if itemsViewModel.fruitsSection {
                                    ItemSection(category: category)
                                }
                            case .grains:
                                if itemsViewModel.grainSection {
                                    ItemSection(category: category)
                                }
                            case .dairy:
                                if itemsViewModel.dairySection {
                                    ItemSection(category: category)
                                }
                            case .meat:
                                if itemsViewModel.meatSection {
                                    ItemSection(category: category)
                                }
                            case .bakedGoods:
                                if itemsViewModel.bakedSection {
                                    ItemSection(category: category)
                                }
                            case .seafood:
                                if itemsViewModel.seaSection {
                                    ItemSection(category: category)
                                }
                            case .nutsAndSeeds:
                                if itemsViewModel.nutsSection {
                                    ItemSection(category: category)
                                }
                            case .herbsAndSpices:
                                if itemsViewModel.herbsSection {
                                    ItemSection(category: category)
                                }
                            case .oil:
                                if itemsViewModel.oilSection {
                                    ItemSection(category: category)
                                }
                            case .processedFoods:
                                if itemsViewModel.processedSection {
                                    ItemSection(category: category)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $itemsViewModel.searchText.onChange {
                itemsViewModel.setSections()
            }, prompt: "Search for an item")
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

struct ItemSection : View {
    @EnvironmentObject var itemsViewModel : ItemsViewModel
    var category : Categories
    
    var body: some View {
        Section {
            ForEach(itemsViewModel.filteredItems) { item in
                if (item as Item).category == category {
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
        } header: {
            Text(category.value)
                .font(.title2)
                .foregroundColor(Color.accentColor)
                .padding(.top, 30)
        }
        .padding(.horizontal, 2)
    }
}

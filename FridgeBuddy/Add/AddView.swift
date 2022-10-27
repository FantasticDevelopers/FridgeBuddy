//
//  AddView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

struct AddView: View {
    @EnvironmentObject var addViewModel : AddViewModel
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(addViewModel.filteredItems) { item in
                        HStack{
                            
                            if let image = item.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .cornerRadius(10)
                            }
                            else {
                                Image("NoImage")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 70)
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
                            
                            Button {
                                addViewModel.item = item
                                addViewModel.isAddingItem.toggle()
                            } label: {
                                Image(systemName: "bag.fill.badge.plus")
                                    .padding()
                                    .background(Color.accentColor.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .searchable(text: $addViewModel.searchText, prompt: "Search for an item")
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        addViewModel.showAddDialog.toggle()
                    } label: {
                        Image(systemName: "plus.viewfinder")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $addViewModel.showCamera) {
            CaptureItemPhotoView()
        }
        .fullScreenCover(isPresented: $addViewModel.showBarcode) {
            BarcodeView()
        }
        .sheet(isPresented: $addViewModel.isAddingItem) {
            if #available(iOS 16.0, *) {
                AddInventoryView(item: addViewModel.item)
                    .presentationDetents([.medium])
            } else {
                AddInventoryView(item: addViewModel.item)
            }
        }
        .confirmationDialog("Add", isPresented: $addViewModel.showAddDialog) {
            Button("Yes") {
                addViewModel.showBarcode.toggle()
            }
            
            Button("No") {
                addViewModel.showCamera.toggle()
            }
        } message: {
            Text("Want to add an item with barcode? Click Yes! \n For non-barcode item, click No!")
        }

    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}

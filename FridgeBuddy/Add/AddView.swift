//
//  AddView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

struct AddView: View {
    @StateObject var addViewModel = AddViewModel()
    
    var body: some View {
        NavigationView {
            List(addViewModel.items, id: \.id) { item in
                HStack{
                    if item.image != nil {
                        Image(uiImage: item.image!)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 70)
                            .cornerRadius(10)
                    } else {
                        Image("NoImage")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 70)
                            .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        
                        Text(item.category)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Add Food item")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        addViewModel.showCamera.toggle()
                    } label: {
                        Image(systemName: "plus.viewfinder")
                    }

                }
            }
            .fullScreenCover(isPresented: $addViewModel.showCamera) {
                CaptureItemPhotoView(addViewModel: addViewModel)
            }
            .onAppear {
                if addViewModel.items.isEmpty {
                    addViewModel.loadItems()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}

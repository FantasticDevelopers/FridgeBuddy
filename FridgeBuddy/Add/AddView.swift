//
//  AddView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

struct AddView: View {
    @StateObject var addViewModel = AddViewModel()
    @EnvironmentObject var launchViewModel : LaunchViewModel
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if !addViewModel.isEditing {
                    HStack {
                        Spacer()
                        
                        Button {
                            addViewModel.showCamera.toggle()
                        } label: {
                            Image(systemName: "plus.viewfinder")
                                .font(.title2)
                        }

                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    HStack {
                        Text("Add Food Item")
                            .fontWeight(.bold)
                        .font(.largeTitle)
                        .overlay(
                            GeometryReader { proxy -> Color in
                                let width = proxy.frame(in: .global).maxX
                                
                                DispatchQueue.main.async {
                                    if addViewModel.titleOffset == 0 {
                                        addViewModel.titleOffset = width
                                    }
                                }
                                
                                return Color.clear
                            }
                            .frame(width: 0, height: 0)
                        )
                        .padding(.horizontal)
                        .scaleEffect(addViewModel.getScale())
                        .offset(addViewModel.getOffset())
                        
                        Spacer()
                    }
                }
                
                SearchBarView(searchText: $addViewModel.searchText, isEditing: $addViewModel.isEditing)
                    .offset(y: addViewModel.offset > 0 && !addViewModel.isEditing ? (addViewModel.offset <= 38 ? -addViewModel.offset : -38) : 0)
            }
            .zIndex(1)
            .padding(.bottom, !addViewModel.isEditing ? addViewModel.getOffset().height : 0)
            .background(
                ZStack {
                    let color = scheme == .dark ? Color.black : Color.white
                    
                    LinearGradient(gradient: .init(colors: [color, color, color, color, color.opacity(1)]), startPoint: .top, endPoint: .bottom)
                }
                    .ignoresSafeArea()
            )
            .overlay(
                GeometryReader { proxy -> Color in
                    let height = proxy.frame(in: .global).maxY
                    
                    DispatchQueue.main.async {
                        if addViewModel.titleBarHeight == 0 {
                            addViewModel.titleBarHeight = height - (UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first?.safeAreaInsets.top ?? 0)
                        }
                    }
                    
                    return Color.clear
                }
            )
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(addViewModel.isEditing ? launchViewModel.items.filter{$0.name.lowercased().contains(addViewModel.searchText.lowercased())} : launchViewModel.items) { item in
                        HStack{
                            
                            if item.image != nil {
                                Image(uiImage: item.image!)
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
                .padding(.top, 20)
                .padding(.top, !addViewModel.isEditing ? addViewModel.titleBarHeight : 50)
                .overlay(
                    GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .global).minY
                        
                        DispatchQueue.main.async {
                            if addViewModel.startOffset == 0 {
                                addViewModel.startOffset = minY
                            }
                            
                            addViewModel.offset = addViewModel.startOffset - minY
                        }
                        
                        return Color.clear
                    }
                    .frame(width: 0, height: 0)
                    ,alignment: .top 
                )
            }
        }
        .fullScreenCover(isPresented: $addViewModel.showCamera) {
                        CaptureItemPhotoView(addViewModel: addViewModel)
        }
        .sheet(isPresented: $addViewModel.isAddingItem) {
            if #available(iOS 16.0, *) {
                AddInventoryView(item: addViewModel.item)
                    .presentationDetents([.medium])
            } else {
                AddInventoryView(item: addViewModel.item)
            }
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

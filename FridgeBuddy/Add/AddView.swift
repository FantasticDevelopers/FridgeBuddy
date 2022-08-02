//
//  AddView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

struct AddView: View {
    @StateObject var addViewModel = AddViewModel()
    @State private var capturedPhoto: UIImage?
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Add View")
                    .padding(.bottom)
            }
            .navigationTitle("Add Food item")
            .offset(y: -60)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        addViewModel.showCamera.toggle()
                    } label: {
                        Image(systemName: "plus.viewfinder")
                    }

                }
            }
            .sheet(isPresented: $addViewModel.showCamera) {
                if capturedPhoto != nil {
                    addViewModel.showForm.toggle()
                }
            } content: {
                CaptureFoodItemPhotoView(capturedImage: $capturedPhoto)
            }
            .sheet(isPresented: $addViewModel.showForm) {
                capturedPhoto = nil
            } content: {
                AddFormView(capturedPhoto: capturedPhoto!)
            }

        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}

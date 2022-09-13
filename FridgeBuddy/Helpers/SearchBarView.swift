//
//  SearchBarView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-09-05.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText : String
    @Binding var isEditing : Bool
    @State var isCancel : Bool = false
    
    var body: some View {
        
        HStack {
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.gray)
                
                TextField("Search for item...", text: $searchText)
                
                if isCancel {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }

                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.primary.opacity(0.05))
            .cornerRadius(8)
            .padding(isEditing ? .leading : .horizontal)
            
            if isCancel {
                Button {
                    withAnimation {
                        isEditing = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        withAnimation {
                            isCancel = false
                        }
                        
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    searchText = ""
                } label: {
                    ButtonView(buttonText: "Cancel", width: 80)
                        .padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                }

            }
        }
        .onTapGesture {
            withAnimation {
                self.isCancel = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                withAnimation {
                    isEditing = true
                }
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""), isEditing: .constant(true))
    }
}

//
//  SecureTextFieldView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-22.
//

import SwiftUI

struct SecureTextFieldView: View {
    var text : String
    @Binding var value : String
    @State var visible : Bool = false
    
    var body: some View {
        HStack {
            if visible {
                TextField(text, text: $value)
            }
            else {
                SecureField(text, text: $value)
            }
            
            Button {
                visible.toggle()
            } label: {
                Image(systemName: visible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(Color.green)
            }
        }
        .padding(.vertical, 10.0)
        .padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 4)
            .stroke(value != "" ? Color.green : Color.black.opacity(0.7), lineWidth: 2))
        .padding(.bottom)
    }
}

struct SecureTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SecureTextFieldView(text: "Password", value: .constant(""))
    }
}

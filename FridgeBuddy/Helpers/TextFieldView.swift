//
//  TextFieldView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-22.
//

import SwiftUI

struct TextFieldView: View {
    var text : String
    @Binding var value : String
    
    var body: some View {
        TextField(text, text: $value)
            .padding(.vertical, 10.0)
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 4)
                .stroke(value != "" ? Color.green : Color.black.opacity(0.7), lineWidth: 2))
            .padding(.bottom)
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(text: "Name", value: .constant(""))
    }
}

//
//  ButtonView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-22.
//

import SwiftUI

struct ButtonView: View {
    var buttonText : String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 200, height: 45)
                .foregroundColor(.green)
                .opacity(0.2)
            
            Text(buttonText)
                .foregroundColor(.green)
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(buttonText: "Sign Up")
    }
}

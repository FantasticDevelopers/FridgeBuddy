//
//  IconView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-22.
//

import SwiftUI

struct IconView: View {
    var body: some View {
        Image("LoginIcon")
            .resizable()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
        
        Text("Fridge Buddy")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(Color.green)
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}

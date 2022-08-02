//
//  AddFormView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-02.
//

import SwiftUI

struct AddFormView: View {
    var capturedPhoto : UIImage
    
    var body: some View {
        Image(uiImage: capturedPhoto)
            .resizable()
            .frame(width: 200, height: 200)
    }
}

struct AddFormView_Previews: PreviewProvider {
   static var capturedPhoto : UIImage = UIImage(imageLiteralResourceName: "LoginIcon")
    
    static var previews: some View {
        AddFormView(capturedPhoto: capturedPhoto)
    }
}

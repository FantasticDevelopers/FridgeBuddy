//
//  MoreView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

struct MoreView: View {
    @StateObject var moreViewModel = MoreViewModel()
    @EnvironmentObject var launchViewModel : LaunchViewModel
    
    var body: some View {
        Button {
            moreViewModel.signOut()
            launchViewModel.checkLogin()
        } label: {
            ButtonView(buttonText: "Sign Out")
        }

    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}

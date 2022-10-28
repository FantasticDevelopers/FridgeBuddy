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
        VStack {
            Text(moreViewModel.name)
                .padding(.vertical, 10.0)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.green, lineWidth: 2))
                .padding(.top)
            
            Spacer()
            
            Button {
                moreViewModel.signOut()
                launchViewModel.checkLogin()
            } label: {
                ButtonView(buttonText: "Sign Out")
            }
            .padding(.bottom)
        }
        .onAppear {
            moreViewModel.getName()
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}

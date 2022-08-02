//
//  LaunchView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var launchViewModel : LaunchViewModel
    
    var body: some View {
        if launchViewModel.isLogin {
            TabView {
                ItemsView()
                    .tabItem {
                        Image(systemName: "list.bullet.circle.fill")
                        Text("Items")
                    }
                AddView()
                    .tabItem {
                        Image(systemName: "plus.app.fill")
                        Text("Add")
                    }
                RecipesView()
                    .tabItem {
                        Image(systemName: "fork.knife.circle.fill")
                        Text("Recipes")
                    }
                MoreView()
                    .tabItem {
                        Image(systemName: "ellipsis.circle.fill")
                        Text("More")
                    }
            }
        }
        else {
            LoginView()
                .onAppear {
                    launchViewModel.checkLogin()
                }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

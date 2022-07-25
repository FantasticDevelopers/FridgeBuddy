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
                    .offset(y: -60)
                    .tabItem {
                        Image(systemName: "list.bullet.circle.fill")
                        Text("Items")
                    }
                AddView()
                    .offset(y: -60)
                    .tabItem {
                        Image(systemName: "plus.app.fill")
                        Text("Add")
                    }
                RecipesView()
                    .offset(y: -60)
                    .tabItem {
                        Image(systemName: "fork.knife.circle.fill")
                        Text("Recipes")
                    }
                MoreView()
                    .offset(y: -60)
                    .tabItem {
                        Image(systemName: "ellipsis.circle.fill")
                        Text("More")
                    }
            }
            .accentColor(Color.green)
        }
        else {
            LoginView()
                .offset(y: -60)
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

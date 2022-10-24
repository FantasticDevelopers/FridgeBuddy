//
//  LaunchView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var launchViewModel : LaunchViewModel
    @EnvironmentObject var addViewModel : AddViewModel
    @EnvironmentObject var itemsViewModel : ItemsViewModel
    
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
            .onAppear {
                if addViewModel.items.isEmpty {
                    addViewModel.loadItems { result in
                        switch result {
                        case .success(let items):
                            itemsViewModel.setUserItems(items: items)
                        case .failure(let error):
                            launchViewModel.alertItem.show(title: "Please try again!", message: error.localizedDescription, buttonTitle: "Got it!")
                        }
                    }
                }
            }
            .alert(launchViewModel.alertItem.title, isPresented: $launchViewModel.alertItem.showAlert) {
                Button(launchViewModel.alertItem.buttonTitle) {}
            } message: {
                launchViewModel.alertItem.message
            }
        }
        else {
            LoginView()
                .onAppear {
                    launchViewModel.checkLogin(firstCheck: true)
                }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

extension Binding {
    func onChange(_ handler: @escaping () -> ()) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}

//
//  LaunchViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth

@MainActor final class LaunchViewModel : ObservableObject {
    @Published var isLogin : Bool = false
    @Published var alertItem = AlertItemView()
    
    func checkLogin(firstCheck : Bool = false) {
        if firstCheck {
            isLogin = Auth.auth().currentUser == nil ? false : true
        } else {
            withAnimation {
                isLogin = Auth.auth().currentUser == nil ? false : true
            }
        }
    }
}

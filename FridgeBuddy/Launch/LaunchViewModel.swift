//
//  LaunchViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI
import FirebaseAuth

@MainActor final class LaunchViewModel : ObservableObject {
    @Published var isLogin : Bool = false
    
    func checkLogin() {
        isLogin = Auth.auth().currentUser == nil ? false : true
    }
}

//
//  LoginViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-22.
//

import SwiftUI
import FirebaseAuth

@MainActor final class LoginViewModel : ObservableObject {
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var alertItem = AlertItemView()
    
    public func signIn() async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            DispatchQueue.main.async { [self] in
                alertItem.show(title: "Please try again!", message: error.localizedDescription, buttonTitle: "Got it!")
            }
        }
    }
}

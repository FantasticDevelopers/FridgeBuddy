//
//  SignViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-22.
//

import SwiftUI
import FirebaseAuth
import Firebase

@MainActor final class SignUpViewModel : ObservableObject {
    @Published var name : String = ""
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var confirmPassword : String = ""
    @Published var alertItem = AlertItemView()
    
    public func signUp() async {
        if checkCorrectPassword() {
            do {
                try await Auth.auth().createUser(withEmail: email, password: password)
            } catch {
                DispatchQueue.main.async { [self] in
                    alertItem.title = Text("Please try again!")
                    alertItem.message = Text("\(error.localizedDescription)")
                    alertItem.buttonTitle = "Got it!"
                    alertItem.showAlert = true
                }
                return
            }
            
            let user = Auth.auth().currentUser
            let db = Firestore.firestore()
            let ref = db.collection("users").document(user!.uid)
            
            do {
                try await ref.setData(["name" : name], merge: true)
            } catch {
                DispatchQueue.main.async { [self] in
                    alertItem.title = Text("Please try again!")
                    alertItem.message = Text("\(error.localizedDescription)")
                    alertItem.buttonTitle = "Got it!"
                    alertItem.showAlert = true
                }
            }
        }
    }
    
    private func checkCorrectPassword() -> Bool {
        if password != confirmPassword {
            alertItem.title = Text("Please try again!")
            alertItem.message = Text("Password and Confirm Password are different")
            alertItem.buttonTitle = "Got it!"
            alertItem.showAlert = true
            return false
        }
        return true
    }
}

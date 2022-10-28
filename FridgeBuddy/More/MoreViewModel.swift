//
//  MoreViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI
import FirebaseAuth
import Firebase

@MainActor final class MoreViewModel : ObservableObject {
    @Published var alertItem = AlertItemView()
    @Published var name : String = ""
    
    func signOut() {
        try! Auth.auth().signOut()
    }
    
    func getName() {
        let db = Firestore.firestore()
        let document = db.collection("users").document(Auth.auth().currentUser!.uid)
        document.getDocument { snapshot, error in
            guard error == nil else {
                self.alertItem.show(title: "Please try again!", message: error!.localizedDescription, buttonTitle: "Got it!")
                return
            }
            
            self.name = (snapshot!.data()!["name"]) as! String
        }
    }
}

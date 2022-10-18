//
//  ItemsDetailViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-10-15.
//

import Foundation
import Firebase
import FirebaseAuth

@MainActor final class ItemsDetailViewModel : ObservableObject {
    @Published var alertItem = AlertItemView()

    func changeItemState(item : Item, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let document = db.collection("users").document(Auth.auth().currentUser!.uid).collection("items").document(item.userItemId!)
        document.setData(["state": item.state!.rawValue], merge: true) { error in
            guard error == nil else {
                self.alertItem.show(title: "Please try again!", message: error!.localizedDescription, buttonTitle: "Got it!")
                return
            }
            completion()
        }
    }
    
}

//
//  AddInventoryViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-09-28.
//

import Foundation
import Firebase
import FirebaseAuth

@MainActor final class AddInventoryViewModel : ObservableObject {
    @Published var quantity : Int = 1
    @Published var expiryDate : Date = Date()
    
    func addToInventory(item : Item) {
        let db = Firestore.firestore()
        let document = db.collection("users").document(Auth.auth().currentUser!.uid).collection("items").document()
        
        document.setData([
            "itemId" : item.id,
            "quantity": quantity,
            "expiryDate": expiryDate,
            "state": item.state!.rawValue,
            "creationDate": Date()
        ])
    }
}

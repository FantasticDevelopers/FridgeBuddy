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
    @Published var alertItem = AlertItemView()
    
    func addToInventory(item : Item, completion: @escaping (Result<Item, Error>) -> Void) {
        let db = Firestore.firestore()
        let document = db.collection("users").document(Auth.auth().currentUser!.uid).collection("items").document()
        
        document.setData([
            "itemId" : item.id,
            "quantity": quantity,
            "expiryDate": expiryDate,
            "state": FoodState.fresh.rawValue,
            "creationDate": Date()
        ]) { error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            let addedItem : Item = Item(id: document.documentID, name: item.name, brand: item.brand, category: item.category, imageReference: item.imageReference, isBarcodeItem: item.isBarcodeItem)
            addedItem.itemId = item.id
            addedItem.image = item.image
            addedItem.quantity = self.quantity
            addedItem.creationDate = Date()
            addedItem.expiryDate = self.expiryDate
            addedItem.expiryDays = item.expiryDays
            addedItem.state = FoodState.fresh
            
            completion(.success(addedItem))
        }
    }
}

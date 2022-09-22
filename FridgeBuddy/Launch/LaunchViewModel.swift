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
    @Published var items : [Item] = []
    
    func checkLogin(firstCheck : Bool = false) {
        if firstCheck {
            isLogin = Auth.auth().currentUser == nil ? false : true
        } else {
            withAnimation {
                isLogin = Auth.auth().currentUser == nil ? false : true
            }
        }
    }
    
    func loadItems() {
        let db = Firestore.firestore()
        
        db.collection("items").getDocuments { [self] snapshot, error in
            guard error == nil else {
                return
            }
            
            if let snapshot = snapshot {
                let items : [Item] = snapshot.documents.map { itemData in
                    let item = Item(id: itemData.documentID, name: itemData["name"] as? String ?? "", brand: itemData["brand"] as? String ?? "", category: itemData["category"] as? String ?? "", imageReference: itemData["imageReference"] as? String ?? "", isBarcodeItem: itemData["isBarcodeItem"] as? Bool ?? false)
                    
                    
                    if let expiryDays = itemData["expiryDays"] as? Int {
                        item.expiryDays = expiryDays
                    }
                    
                    if let upc = itemData["upc"] as? String {
                        item.upc = upc
                    }
                    
                    return item
                }
                
                DispatchQueue.main.async {
                    self.items = items
                }
                
                let storageRef = Storage.storage().reference()
                var count = 0
                for (index, item) in items.enumerated() {
                    let fileRef = storageRef.child(item.imageReference)
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        guard error == nil && data != nil else {
                            return
                        }
                        count += 1
                        items[index].image = UIImage(data: data!)
                        DispatchQueue.main.async {
                                self.items = items
                        }
                    }
                }
            }
        }
    }
}

//
//  AddInventoryViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-09-28.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

@MainActor final class AddInventoryViewModel : ObservableObject {
    @Published var quantity : Int = 1
    @Published var expiryDate : Date = Date()
    @Published var alertItem = AlertItemView()
    
    func addToInventory(item : Item, completion: @escaping (Result<[Item], Error>) -> Void) {
        let db = Firestore.firestore()
        
        if item.id.isEmpty {
            let storageRef = Storage.storage().reference()
            let imageData = item.image!.jpegData(compressionQuality: 0.8)
            
            guard imageData != nil else {
                let error : Error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image cannot be added."])
                completion(.failure(error))
                return
            }
            
            item.imageReference = "itemsImage/\(UUID().uuidString).jpeg"
            let fileRef = storageRef.child(item.imageReference)
            
            fileRef.putData(imageData!, metadata: nil) { [self] metaData, error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                let calendar = Calendar.current
                let currentDate = calendar.startOfDay(for: Date())
                let expiry = calendar.startOfDay(for: expiryDate)
                
                let components = calendar.dateComponents([.day], from: currentDate, to: expiry)
                item.expiryDays = components.day
                
                
                let document = db.collection("items").document()
                document.setData(["name": item.name,
                                  "brand": item.brand,
                                  "expiryDays": item.expiryDays!,
                                  "imageReference": item.imageReference,
                                  "isBarcodeItem": item.isBarcodeItem,
                                  "upc": item.upc!]) { error in
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                    
                    let addedItem : Item = Item(id: document.documentID, name: item.name, brand: item.brand, imageReference: item.imageReference, isBarcodeItem: item.isBarcodeItem)
                    addedItem.upc = item.upc
                    addedItem.image = item.image
                    addedItem.expiryDays = item.expiryDays
                    
                    let userDocument = db.collection("users").document(Auth.auth().currentUser!.uid).collection("items").document()
                    
                    userDocument.setData([
                        "itemId" : addedItem.id,
                        "quantity": self.quantity,
                        "expiryDate": self.expiryDate,
                        "state": FoodState.fresh.rawValue,
                        "creationDate": Date()
                    ]) { error in
                        guard error == nil else {
                            completion(.failure(error!))
                            return
                        }
                        
                        let userItem : Item = Item(id: userDocument.documentID, name: item.name, brand: item.brand, imageReference: item.imageReference, isBarcodeItem: item.isBarcodeItem)
                        userItem.upc = item.upc
                        userItem.itemId = addedItem.id
                        userItem.image = item.image
                        userItem.quantity = self.quantity
                        userItem.creationDate = Date()
                        userItem.expiryDate = self.expiryDate
                        userItem.expiryDays = item.expiryDays
                        userItem.state = FoodState.fresh
                        
                        completion(.success([userItem, addedItem]))
                    }
                }
            }
        } else {
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
                
                let userItem : Item = Item(id: document.documentID, name: item.name, brand: item.brand, imageReference: item.imageReference, isBarcodeItem: item.isBarcodeItem)
                userItem.itemId = item.id
                userItem.image = item.image
                userItem.quantity = self.quantity
                userItem.creationDate = Date()
                userItem.expiryDate = self.expiryDate
                userItem.expiryDays = item.expiryDays
                userItem.state = FoodState.fresh
                
                completion(.success([userItem]))
            }
        }
    }
}

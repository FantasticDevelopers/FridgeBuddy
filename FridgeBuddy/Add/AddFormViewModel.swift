//
//  AddFormViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-02.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

@MainActor final class AddFormViewModel : ObservableObject {
    @Published var item = Item()
    @Published var alertItem = AlertItemView()
    @Published var expiryDate : Date = Date()
    @Published var quantity : Int = 1
    
    public func addNonBarcodeItem(completion: @escaping (Result<[Item], Error>) -> Void) {
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
            
            item.expiryDate = expiryDate
            calculateExpiryDays()
            
            let db = Firestore.firestore()
            
            let document = db.collection("items").document()
            
            document.setData([
                "name": item.name,
                "brand": item.brand,
                "category": item.category.rawValue,
                "expiryDays": item.expiryDays!,
                "imageReference": item.imageReference,
                "isBarcodeItem": item.isBarcodeItem
            ]) { error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                let item : Item = Item(id: document.documentID, name: self.item.name, brand: self.item.brand, category: self.item.category, imageReference: self.item.imageReference, isBarcodeItem: self.item.isBarcodeItem)
                item.image = self.item.image
                item.expiryDays = self.item.expiryDays
                item.state = FoodState.fresh
                item.quantity = self.quantity
                item.expiryDate = self.expiryDate
                
                let userDocument = db.collection("users").document(Auth.auth().currentUser!.uid).collection("items").document()
                
                userDocument.setData([
                    "itemId" : item.id,
                    "quantity": item.quantity!,
                    "expiryDate": item.expiryDate!,
                    "state": item.state!.rawValue,
                    "creationDate": Date()
                ]) { error in
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                    
                    let userItem : Item = Item(id: userDocument.documentID, name: item.name, brand: item.brand, category: item.category, imageReference: item.imageReference, isBarcodeItem: item.isBarcodeItem)
                    userItem.itemId = item.id
                    userItem.creationDate = Date()
                    userItem.image = item.image
                    userItem.expiryDays = item.expiryDays
                    userItem.state = FoodState.fresh
                    userItem.quantity = item.quantity
                    userItem.expiryDate = item.expiryDate
                    
                    let items : [Item] = [item, userItem]
                    
                    completion(.success(items))
                }
            }
        }
    }
    
    private func calculateExpiryDays() {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let expiryDate = calendar.startOfDay(for: expiryDate)
        
        let components = calendar.dateComponents([.day], from: currentDate, to: expiryDate)
        item.expiryDays = components.day
    }
}

//
//  AddFormViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-02.
//

import SwiftUI
import Firebase
import FirebaseStorage

@MainActor final class AddFormViewModel : ObservableObject {
    @Published var item = Item()
    @Published var alertItem = AlertItemView()
    
    public func addNonBarcodeItem(completion: @escaping (Item?) -> Void) {
        let storageRef = Storage.storage().reference()
        let imageData = item.image!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            alertItem.show(title: "Please try again!", message: "Image cannot be added.", buttonTitle: "Got it!")
            return
        }
        
        item.imageReference = "itemsImage/\(UUID().uuidString).jpeg"
        let fileRef = storageRef.child(item.imageReference)
        
        fileRef.putData(imageData!, metadata: nil) { [self] metaData, error in
            guard error == nil && metaData != nil else {
                alertItem.show(title: "Please try again!", message: error!.localizedDescription, buttonTitle: "Got it!")
                return
            }
            
            calculateExpiryDays()
            
            let db = Firestore.firestore()
            
            let document = db.collection("items").document()
            
            document.setData([
                "name": item.name,
                "brand": item.brand,
                "category": item.category,
                "state": "Fresh",
                "quantity": item.quantity,
                "expiryDate": Timestamp(date: item.expiryDate),
                "expiryDays": item.expiryDays!,
                "imageReference": item.imageReference,
                "isBarcodeItem": item.isBarcodeItem
            ]) { error in
                guard error == nil else {
                    self.alertItem.show(title: "Please try again!", message: error!.localizedDescription, buttonTitle: "Got it!")
                    return
                }
                
                let item : Item = Item(id: document.documentID, name: self.item.name, brand: self.item.brand, category: self.item.category, state: self.item.state, quantity: self.item.quantity, expiryDate: self.item.expiryDate, imageReference: self.item.imageReference, isBarcodeItem: self.item.isBarcodeItem)
                item.image = self.item.image
                item.expiryDays = self.item.expiryDays
                
                completion(item)
            }
        }
    }
    
    private func calculateExpiryDays() {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let expiryDate = calendar.startOfDay(for: item.expiryDate)
        
        let components = calendar.dateComponents([.day], from: currentDate, to: expiryDate)
        item.expiryDays = components.day
    }
}

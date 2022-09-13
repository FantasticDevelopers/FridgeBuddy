//
//  AddViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI
import Firebase
import FirebaseStorage

@MainActor final class AddViewModel : ObservableObject {
    @Published var showCamera : Bool = false
    @Published var items : [Item] = []
    @Published var searchText : String = ""
    @Published var isEditing : Bool = false
    @Published var offset : CGFloat = 0
    @Published var startOffset : CGFloat = 0
    @Published var titleOffset : CGFloat = 0
    @Published var titleBarHeight : CGFloat = 0
    
    public func loadItems() {
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
    
    public func getOffset() -> CGSize {
        var size : CGSize = .zero
        let screenWidth = UIScreen.main.bounds.width / 2.1
        
        size.width = (offset > 0) ? (offset * 1.5 <= (screenWidth - titleOffset) ? offset * 1.5 : (screenWidth - titleOffset)) : 0
        size.height = (offset > 0) ? (offset <= 36 ? -offset : -36) : 0
        
        return size
    }
    
    public func getScale() -> CGFloat {
        if offset > 0 {
            let screenWidth = UIScreen.main.bounds.width
            let progress = 1 - (getOffset().width / screenWidth)
            return progress >= 0.9 ? progress : 0.9
        } else {
            return 1
        }
    }
}

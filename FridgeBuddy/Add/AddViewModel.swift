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
    @Published var showAddDialog : Bool = false
    @Published var showBarcode : Bool = false
    @Published var showCamera : Bool = false
    @Published var isAddingItem : Bool = false
    @Published var searchText : String = ""
    var filteredItems : [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    @Published var items : [Item] = []
    var item : Item = Item()
    
    func loadItems(completion: @escaping (Result<[Item], Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("items").getDocuments { [self] snapshot, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            if let snapshot = snapshot {
                let items : [Item] = snapshot.documents.map { itemData in
                    let item = Item(id: itemData.documentID, name: itemData["name"] as? String ?? "", brand: itemData["brand"] as? String ?? "", category: Categories.get(at: itemData["category"] as? Int ?? 0), imageReference: itemData["imageReference"] as? String ?? "", isBarcodeItem: itemData["isBarcodeItem"] as? Bool ?? false)
                    
                    
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
                            completion(.failure(error!))
                            return
                        }
                        count += 1
                        items[index].image = UIImage(data: data!)
                        DispatchQueue.main.async {
                                self.items = items
                        }
                        
                        if count == items.count {
                            completion(.success(items))
                        }
                    }
                }
            }
        }
    }
}

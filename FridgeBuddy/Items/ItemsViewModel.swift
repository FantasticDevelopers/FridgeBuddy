//
//  ItemsViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import Foundation
import Firebase
import FirebaseAuth

@MainActor final class ItemsViewModel : ObservableObject {
    @Published var items : [Item] = []
    @Published var selectedState : FoodState = .fresh
    var filteredItems : [Item] {
        if searchText == "" {
            var selectedItems : [Item] = []
            selectedItems =  items.filter { $0.state == selectedState }
            return selectedItems
        } else {
            var selectedItems : [Item] = []
            selectedItems =  items.filter { $0.state == selectedState }
            selectedItems = selectedItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            return selectedItems
        }
    }
    
    @Published var searchText : String = ""
    @Published var alertItem = AlertItemView()
    @Published var vegetablesSection : Bool = false
    @Published var fruitsSection : Bool = false
    @Published var grainSection : Bool = false
    @Published var dairySection : Bool = false
    @Published var meatSection : Bool = false
    @Published var bakedSection : Bool = false
    @Published var seaSection : Bool = false
    @Published var nutsSection : Bool = false
    @Published var herbsSection : Bool = false
    @Published var oilSection : Bool = false
    @Published var processedSection : Bool = false
    @Published var showDetails : Bool = false
    
    var item : Item = Item()
    
    func setUserItems(items : [Item]) {
        let db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("items").getDocuments { snapshot, error in
            guard error == nil else {
                self.alertItem.show(title: "Please try again!", message: error!.localizedDescription, buttonTitle: "Got it!")
                return
            }
            
            if let snapshot = snapshot {
                DispatchQueue.main.async { [self] in
                    self.items = snapshot.documents.map { itemData in
                        let id = itemData["itemId"] as! String
                        let item : Item = items.filter { $0.id == id }.first!
                        item.userItemId = itemData.documentID
                        item.quantity = itemData["quantity"] as? Int
                        item.creationDate = (itemData["creationDate"] as! Timestamp).dateValue()
                        item.expiryDate = (itemData["expiryDate"] as! Timestamp).dateValue()
                        item.state = FoodState.get(at: itemData["state"] as! Int)
                        return item
                    }
                    setSections()
                }
            }
        }
    }
    
    func formatDate(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    func setSections() {
        vegetablesSection = false
        fruitsSection = false
        grainSection = false
        dairySection = false
        meatSection = false
        bakedSection = false
        seaSection = false
        nutsSection = false
        herbsSection = false
        oilSection = false
        processedSection = false

        for category in Categories.allCases {
            var items : [Item] = []
            items = filteredItems.filter { $0.category == category }
            if items.count > 0 {
                switch category {
                case .vegetables:
                    vegetablesSection = true
                case .fruits:
                    fruitsSection = true
                case .grains:
                    grainSection = true
                case .dairy:
                    dairySection = true
                case .meat:
                    meatSection = true
                case .bakedGoods:
                    bakedSection = true
                case .seafood:
                    seaSection = true
                case .nutsAndSeeds:
                    nutsSection = true
                case .herbsAndSpices:
                    herbsSection = true
                case .oil:
                    oilSection = true
                case .processedFoods:
                    processedSection = true
                }
            }
        }
    }
}

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
    var items : [Item] = []
    @Published var freshItems : [Item] = []
    @Published var staleItems : [Item] = []
    @Published var expiredItems : [Item] = []
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
    @Published var selectedState : FoodState = .fresh
    
    func setUserItems(items : [Item]) {
        let db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("items").getDocuments { snapshot, error in
            guard error == nil else {
                return
            }
            
            if let snapshot = snapshot {
                DispatchQueue.main.async { [self] in
                    self.items = snapshot.documents.map { itemData in
                        let id = itemData["itemId"] as! String
                        let item : Item = items.filter { $0.id == id }.first!
                        item.quantity = itemData["quantity"] as? Int
                        item.creationDate = (itemData["creationDate"] as! Timestamp).dateValue()
                        item.expiryDate = (itemData["expiryDate"] as! Timestamp).dateValue()
                        item.state = FoodState.get(at: itemData["state"] as! Int)
                        return item
                    }
                    freshItems = items.filter { $0.state == .fresh }
                    staleItems = items.filter { $0.state == .stale }
                    expiredItems = items.filter { $0.state == .expired }
                    setSections(state: FoodState.fresh)
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
    
    func setSections(state : FoodState) {
        self.vegetablesSection = false
        self.fruitsSection = false
        self.grainSection = false
        self.dairySection = false
        self.meatSection = false
        self.bakedSection = false
        self.seaSection = false
        self.nutsSection = false
        self.herbsSection = false
        self.oilSection = false
        self.processedSection = false
        
        switch state {
        case .fresh:
            for item in freshItems {
                changeSection(item: item)
            }
        case .stale:
            for item in staleItems {
                changeSection(item: item)
            }
        case .expired:
            for item in expiredItems {
                changeSection(item: item)
            }
        }
    }
    
    func changeSection(item : Item) {
        if !vegetablesSection {
            if item.category == .vegetables {
                vegetablesSection = true
                return
            }
        }
        
        if !fruitsSection {
            if item.category == .fruits {
                fruitsSection = true
                return
            }
        }
        
        if !grainSection {
            if item.category == .grains {
                grainSection = true
                return
            }
        }
        
        if !dairySection {
            if item.category == .dairy {
                dairySection = true
            }
        }
        
        if !meatSection {
            if item.category == .meat {
                meatSection = true
                return
            }
        }
        
        if !bakedSection {
            if item.category == .bakedGoods {
                bakedSection = true
            }
        }
        
        if !seaSection {
            if item.category == .seafood {
                seaSection = true
                return
            }
        }
        
        if !nutsSection {
            if item.category == .nutsAndSeeds {
                nutsSection = true
                return
            }
        }
        
        if !herbsSection {
            if item.category == .herbsAndSpices {
                herbsSection = true
                return
            }
        }
        
        if !oilSection {
            if item.category == .oil {
                oilSection = true
                return
            }
        }
        
        if !processedSection {
            if item.category == .processedFoods {
                processedSection = true
                return
            }
        }
    }
}

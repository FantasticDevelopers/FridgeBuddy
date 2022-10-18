//
//  Item.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-08-06.
//

import Foundation
import SwiftUI

class Item : Identifiable {
    let id : String
    var userItemId : String?
    var name : String
    var brand : String
    var category : Categories
    var state : FoodState?
    var quantity : Int?
    var expiryDate : Date?
    var expiryDays : Int?
    var upc : String?
    var image : UIImage?
    var imageReference : String
    var isBarcodeItem : Bool
    var creationDate : Date?
    
    init() {
        self.id = ""
        self.name = ""
        self.brand = ""
        self.category = .vegetables
        self.quantity = 1
        self.expiryDate = Date()
        self.imageReference = ""
        self.isBarcodeItem = false
    }
    
    init(id : String, name : String, brand : String, category : Categories, imageReference : String, isBarcodeItem : Bool) {
        self.id = id
        self.name = name
        self.brand = brand
        self.category = category
        self.imageReference = imageReference
        self.isBarcodeItem = isBarcodeItem
    }
}

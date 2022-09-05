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
    var name : String
    var brand : String
    var category : String
    var state : String
    var quantity : Int
    var expiryDate : Date
    var expiryDays : Int?
    var upc : String?
    var image : UIImage?
    var imageReference : String
    var isBarcodeItem : Bool
    
    init() {
        self.id = ""
        self.name = ""
        self.brand = ""
        self.category = ""
        self.state = ""
        self.quantity = 1
        self.expiryDate = Date()
        self.imageReference = ""
        self.isBarcodeItem = false
    }
    
    init(id : String, name : String, brand : String, category : String, state : String, quantity : Int, expiryDate : Date, imageReference : String, isBarcodeItem : Bool) {
        self.id = id
        self.name = name
        self.brand = brand
        self.category = category
        self.state = state
        self.quantity = quantity
        self.expiryDate = expiryDate
        self.imageReference = imageReference
        self.isBarcodeItem = isBarcodeItem
    }
}

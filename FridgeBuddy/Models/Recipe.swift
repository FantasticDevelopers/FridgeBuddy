//
//  Recipe.swift
//  FridgeBuddy
//
//  Created by Inderdeep on 2022-10-27.
//

import Foundation

struct Recipe: Codable,Identifiable{
    var id : Int
    var title: String
    var image : String
    var imageType : String?
    var usedIngredientCount : Int
    var missedIngredientCount : Int
    //var missedIngredients : [Ingredient]?
    //var usedIngredients : [Ingredient]?
    //var unusedIngredients : [Ingredient]?
    var likes : Int
    
}

struct Recipes: Codable,Identifiable{
    var uid = UUID()
    var id : Int
    var title: String
    var image : String
    var imageType : String?
    var usedIngredientCount : Int
    var missedIngredientCount : Int
    //var missedIngredients : [Ingredient]?
    //var usedIngredients : [Ingredient]?
    //var unusedIngredients : [Ingredient]?
    var likes : Int
    
    init() {
        self.id = 0
        self.title = ""
        self.image = ""
        self.usedIngredientCount = 0
        self.missedIngredientCount = 0
        self.likes = 0
    }
    init(r_id : Int, t : String, img : String, uIng : Int, mIng : Int, lik : Int) {
        self.id = r_id
        self.title = t
        self.image = img
        self.usedIngredientCount = mIng
        self.missedIngredientCount = uIng
        self.likes = lik
    }
}

struct Ingredient : Codable{
    var id : Int?
    var amount : Double?
    var unit : String?
    var unitLong :String?
    var unitShort : String?
    var aisle : String?
    var name : String?
    var original : String?
    var originalName : String?
    var meta : [Meta]?
    var image : String?
    
}

struct Meta: Codable{
    var message : String?
}

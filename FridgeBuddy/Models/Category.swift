//
//  Category.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-09-21.
//

import Foundation

enum Categories : Int, CaseIterable {
    case vegetables
    case fruits
    case grains
    case dairy
    case meat
    case bakedGoods
    case seafood
    case nutsAndSeeds
    case herbsAndSpices
    case oil
    case processedFoods
    
    var value : String {
        switch self {
        case .vegetables:
            return "Vegetables"
        case .fruits:
            return "Fruits"
        case .grains:
            return "Grains"
        case .dairy:
            return "Dairy"
        case .meat:
            return "Meat"
        case .bakedGoods:
            return "Baked Goods"
        case .seafood:
            return "Seafood"
        case .nutsAndSeeds:
            return "Nuts and Seeds"
        case .herbsAndSpices:
            return "Herbs and Spices"
        case .oil:
            return "Oil"
        case .processedFoods:
            return "Processed Foods"
        }
    }
        
    static func get(at index : Int) -> Categories {
        for category in Categories.allCases {
            if category.rawValue == index {
                return category
            }
        }
        return .vegetables
    }
}

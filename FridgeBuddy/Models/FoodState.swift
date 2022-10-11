//
//  FoodState.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-09-22.
//

import Foundation

enum FoodState : Int, CaseIterable {
    case fresh
    case stale
    case expired
    
    var value : String {
        switch self {
        case .fresh:
            return "Fresh"
        case .stale:
            return "Stale"
        case .expired:
            return "Expired"
        }
    }
    
    static func get(at index : Int) -> FoodState {
        for state in FoodState.allCases {
            if state.rawValue == index {
                return state
            }
        }
        return .fresh
    }
}

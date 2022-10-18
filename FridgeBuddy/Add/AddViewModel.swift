//
//  AddViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

@MainActor final class AddViewModel : ObservableObject {
    @Published var showCamera : Bool = false
    @Published var searchText : String = ""
    @Published var isEditing : Bool = false
    @Published var offset : CGFloat = 0
    @Published var startOffset : CGFloat = 0
    @Published var titleOffset : CGFloat = 0
    @Published var titleBarHeight : CGFloat = 0
    @Published var isAddingItem : Bool = false
    var item : Item = Item()
    
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

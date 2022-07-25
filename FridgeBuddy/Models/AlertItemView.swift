//
//  AlertItemView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-23.
//

import SwiftUI

struct AlertItemView: Identifiable {
    let id = UUID()
    var title : Text = Text("")
    var message : Text = Text("")
    var buttonTitle : String = ""
    var showAlert : Bool = false
}


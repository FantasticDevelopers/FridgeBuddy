//
//  MoreViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI
import FirebaseAuth

@MainActor final class MoreViewModel : ObservableObject {
    
    func signOut() {
        try! Auth.auth().signOut()
    }
}

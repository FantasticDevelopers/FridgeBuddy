//
//  AddViewModel.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

@MainActor final class AddViewModel : ObservableObject {
    @Published var showCamera : Bool = false
    @Published var showForm : Bool = false
}

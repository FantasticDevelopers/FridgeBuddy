//
//  FridgeBuddyApp.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-20.
//

import SwiftUI

@main
struct FridgeBuddyApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(LaunchViewModel())
                .environmentObject(AddViewModel())
                .environmentObject(ItemsViewModel())
        }
    }
}

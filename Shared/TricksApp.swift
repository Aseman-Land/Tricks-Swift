//
//  TricksApp.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI

@main
struct TricksApp: App {
    
    @StateObject var profile = MyProfileViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(profile)
        }
        .commands {
            SidebarCommands()
        }
        
        #if os(macOS)
        Settings {
            SettingsView()
                .environmentObject(profile)
        }
        #endif
    }
}

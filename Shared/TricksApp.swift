//
//  TricksApp.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI

@main
struct TricksApp: App {
    
    @StateObject var profile = Profile()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(profile)
        }
        .commands {
            SidebarCommands()
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        #endif
        
        
    }
}

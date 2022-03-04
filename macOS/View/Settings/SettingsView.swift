//
//  SettingsView.swift
//  Tricks (macOS)
//
//  Created by Armin on 3/1/22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var profile: ProfileViewModel
    
    var body: some View {
        TabView {
            /// Account settings
            AccountSettingsView()
                .environmentObject(profile)
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
            
            /// Editor settings
            EditorSettingsView()
                .tabItem {
                    Label("Editor", systemImage: "square.and.pencil")
                }
            
            AdvancedSettingsView()
                .tabItem {
                    Label("Advanced", systemImage: "gearshape.2")
                }
        }
        .padding(20)
        .frame(minWidth: 450, minHeight: 250)
        
    }
}

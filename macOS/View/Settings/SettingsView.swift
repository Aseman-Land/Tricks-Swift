//
//  SettingsView.swift
//  Tricks (macOS)
//
//  Created by Armin on 3/1/22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var profile: ProfileViewModel
    
    private enum Tabs: Hashable {
        case general, editor, account
    }
    var body: some View {
        TabView {
            /// General settings
            withAnimation {
                GeneralSettingsView()
            }
            .tabItem {
                Label("General", systemImage: "gearshape")
            }
            .tag(Tabs.general)
            
            /// Editor settings
            withAnimation {
                EditorSettingsView()
            }
            .tabItem {
                Label("Editor", systemImage: "square.and.pencil")
            }
            .tag(Tabs.editor)
            
            /// Account settings
            withAnimation {
                AccountSettingsView()
                    .environmentObject(profile)
            }
            .tabItem {
                Label("Account", systemImage: "person.crop.circle")
            }
            .tag(Tabs.account)
        }
        .padding(20)
        .frame(minWidth: 450, minHeight: 250)
        
    }
}

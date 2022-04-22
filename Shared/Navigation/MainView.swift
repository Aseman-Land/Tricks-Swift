//
//  MainView.swift
//  Tricks
//
//  Created by armin on 2/18/22.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    @State private var showRegister: Bool = false
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var body: some View {
        ZStack {
            if profile.isUserLoggedIn {
                // MARK: - Dashboard view
                #if os(iOS)
                if horizontalSizeClass == .compact {
                    TabNavigation()
                } else {
                    Sidebar()
                }
                #else
                Sidebar()
                    .task {
                        titleBarVisibility(hidden: false)
                    }
                #endif
            } else {
                // MARK: - Login and register views
                if showRegister {
                    SignupView {
                        withAnimation {
                            showRegister.toggle()
                        }
                    }
                    .task {
                        titleBarVisibility(hidden: true)
                    }
                } else {
                    LoginView {
                        withAnimation {
                            showRegister.toggle()
                        }
                    }
                    .task {
                        titleBarVisibility(hidden: true)
                    }
                }
            }
        }
        .environmentObject(profile)
    }
    
    
    func titleBarVisibility(hidden: Bool) {
        #if os(macOS)
        NSApplication.shared.windows.first?.titlebarAppearsTransparent = hidden
        NSApplication.shared.windows.first?.titleVisibility = hidden ? .hidden : .visible
        #endif
    }
    
}

struct MainView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        MainView()
            .environmentObject(profile)
    }
}

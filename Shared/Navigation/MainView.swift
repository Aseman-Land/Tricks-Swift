//
//  MainView.swift
//  Tricks
//
//  Created by armin on 2/18/22.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var profile: Profile
    
    @State private var showRegister: Bool = false
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var body: some View {
        Group {
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
                #endif
            } else {
                // MARK: - Login and register views
                if showRegister {
                    SignupView {
                        withAnimation {
                            showRegister.toggle()
                        }
                    }
                } else {
                    LoginView {
                        withAnimation {
                            showRegister.toggle()
                        }
                    }
                }
            }
        }
        .environmentObject(profile)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

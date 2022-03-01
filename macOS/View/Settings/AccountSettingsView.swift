//
//  AccountSettingsView.swift
//  Tricks (macOS)
//
//  Created by Armin on 3/1/22.
//

import SwiftUI

struct AccountSettingsView: View {
    @EnvironmentObject var profile: ProfileViewModel
    
    var body: some View {
        if profile.isUserLoggedIn {
            VStack {
                ZStack {
                    if !profile.loading {
                        Button("Logout", role: .destructive) {
                            Task.init {
                                await profile.logout()
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .headerProminence(.increased)
                        .padding()
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    }
                }
                .padding()
                
                Text(profile.errorMessage)
                    .foregroundColor(.red)
            }
        } else {
            Text("You are not logged in")
                .padding()
        }
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView()
    }
}

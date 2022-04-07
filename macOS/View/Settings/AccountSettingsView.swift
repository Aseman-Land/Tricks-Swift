//
//  AccountSettingsView.swift
//  Tricks (macOS)
//
//  Created by Armin on 3/1/22.
//

import SwiftUI
import NukeUI

struct AccountSettingsView: View {
    @EnvironmentObject var profile: MyProfileViewModel
    
    @AppStorage("fullname") private var storageFullname = ""
    @AppStorage("username") private var storageUsername = ""
    @AppStorage("avatarAddress") private var storageAvatarAddress = ""
    
    var body: some View {
        if profile.isUserLoggedIn {
            Form {
                HStack {
                    // MARK: - Profile avatar
                    ZStack {
                        Circle()
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                        LazyImage(source: storageAvatarAddress) { state in
                            if let image = state.image {
                                image
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                        }
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 38, height: 38, alignment: .center)
                        .padding(.all, 2)
                    }
                    .frame(width: 40, height: 40)
                    .shadow(radius: 1)
                    
                    
                    VStack(alignment: .leading) {
                        // MARK: - Profile Fullname
                        Text(storageFullname)
                            .font(.title3)
                            .foregroundStyle(.primary)
                        
                        // MARK: - Profile username
                        Text("@\(storageUsername)")
                            .font(.body)
                            .fontWeight(.light)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    // MARK: - Logout
                    HStack {
                        Text(profile.errorMessage)
                            .foregroundColor(.red)
                        
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
                    }
                }
                .padding()
            }
        } else {
            Text("You are not logged in")
                .padding()
        }
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        AccountSettingsView()
            .environmentObject(profile)
    }
}

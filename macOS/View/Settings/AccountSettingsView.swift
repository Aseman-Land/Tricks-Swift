//
//  AccountSettingsView.swift
//  Tricks (macOS)
//
//  Created by Armin on 3/1/22.
//

import SwiftUI
import NukeUI

struct AccountSettingsView: View {
    @StateObject var accountModel = AccountSettingsViewModel()
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    @AppStorage("avatarAddress") private var storageAvatarAddress = ""
    
    var body: some View {
        if profile.isUserLoggedIn {
            Form {
                HStack(alignment: .top) {
                    // MARK: - Profile avatar
                    Button(action: {
                        Task.init {
                            await accountModel.showImagePicker()
                        }
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(.white)
                                .frame(width: 75, height: 75)
                            LazyImage(url: URL(string: storageAvatarAddress)) { state in
                                if let image = state.image {
                                    image
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                            }
                            .overlay(alignment: .bottom) {
                                if accountModel.editAvatarloading {
                                    ZStack {
                                        Color.black.opacity(0.5)
                                        
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                    }
                                } else {
                                    Text("Edit")
                                        .font(.footnote)
                                        .frame(maxWidth: .infinity)
                                        .background(.ultraThinMaterial)
                                }
                            }
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 66, height: 66, alignment: .center)
                            .padding(.all, 2)
                        }
                        .frame(width: 75, height: 75)
                        
                    })
                    .frame(width: 75, height: 75)
                    .buttonStyle(.borderless)
                    .padding()
                    
                    VStack {
                        Section("General Details") {
                            TextField("Full name", text: $accountModel.fullname)
                            
                            TextField("Username", text: $accountModel.username)
                        }
                        .textFieldStyle(.roundedBorder)
                        
                        Divider()
                        
                        Section("Security") {
                            SecureField("Current Password", text: $accountModel.currentPass)
                            
                            SecureField("New Password", text: $accountModel.newPass)
                            
                            SecureField("Repeat New Password", text: $accountModel.repeatNewPass)
                        }
                        .textFieldStyle(.roundedBorder)
                        
                        Divider()
                        
                        Section("Other") {
                            TextField("Bio", text: $accountModel.bio)
                        }
                        .textFieldStyle(.roundedBorder)
                        
                        HStack {
                            Spacer()
                            VStack {
                                ZStack {
                                    if !accountModel.editProfileloading {
                                        Button("Save Changes") {
                                            Task.init {
                                                await accountModel.editProfile()
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                        .controlSize(.large)
                                        .headerProminence(.increased)
                                    } else {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                    }
                                }
                                .padding(.vertical)
                                
                                if accountModel.errorMessage != "" {
                                    Text(accountModel.errorMessage)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.top)
                        
                        Divider()
                    }
                }
                
                // MARK: - Logout
                VStack {
                    ZStack {
                        if !profile.loading {
                            Button("Logout", role: .destructive) {
                                Task.init {
                                    await profile.logout()
                                }
                            }
                            .foregroundColor(.red)
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .headerProminence(.increased)
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        }
                    }
                    .padding(.vertical)
                    
                    if profile.errorMessage != "" {
                        Text(profile.errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .task {
                accountModel.profile = profile
                accountModel.fillFields()
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

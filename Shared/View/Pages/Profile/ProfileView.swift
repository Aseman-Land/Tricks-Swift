//
//  ProfileView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI
import NukeUI

struct ProfileView: View {
    
    @StateObject private var profileModel: ProfileViewModel
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    init(viewModel: @autoclosure @escaping () -> ProfileViewModel) {
        _profileModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        TricksListView(viewModel: TricksListViewModel(profileModel.userId == "me" ? .me : .user(userID: profileModel.userId))) {
            UserView()
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .environmentObject(profile)
        .task {
            profileModel.profile = profile
            await profileModel.getProfile()
        }
        #if os(iOS)
        .sheet(isPresented: $profileModel.showSettings) {
            SettingsView()
                .environmentObject(profile)
        }
        .fullScreenCover(isPresented: $profileModel.showAvatarPreview) {
            AvatarPreview(imageAddress: profileModel.userResult?.avatarAddress ?? "")
        }
        .toolbar {
            ToolbarItem {
                if profileModel.userId == "me" {
                    Button(action: { profileModel.showSettings = true }) {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        #elseif os(macOS)
        .onChange(of: profileModel.showAvatarPreview) { _ in
            AvatarPreview(imageAddress: profileModel.userResult?.avatarAddress)
                .frame(minWidth: 512, minHeight: 484)
                .openInWindow(title: profileModel.userResult?.fullname ?? "", sender: self, transparentTitlebar: true)
        }
        #endif
    }
    
    @ViewBuilder
    func UserView() -> some View {
        VStack(spacing: 12) {
            // MARK: - User avatar
            Button(action: {
                profileModel.showAvatarPreview.toggle()
            }, label: {
                ZStack {
                    Circle()
                        .foregroundStyle(.ultraThickMaterial)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 2)
                    LazyImage(url: profileModel.userResult?.avatarAddress) { state in
                        if let image = state.image {
                            image
                        } else {
                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70, alignment: .center)
                    .clipShape(Circle())
                }
                .frame(width: 80, height: 80)
                .padding()
            })
            .frame(width: 80, height: 80)
            .buttonStyle(.borderless)
            
            VStack {
                // MARK: - User's name
                Text(profileModel.userResult?.fullname ?? "       ")
                    .font(.title)
                    .fontWeight(.medium)
                    .dynamicTypeSize(.xSmall ... .large)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .redacted(reason: profileModel.userResult?.fullname.trimmingCharacters(in: .whitespaces).isEmpty ?? true ? .placeholder : [])
                
                // MARK: - Username
                Text("@" + (profileModel.userResult?.username ?? "     "))
                    .font(.body)
                    .fontWeight(.light)
                    .dynamicTypeSize(.xSmall ... .large)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(.secondary)
                    .redacted(reason: profileModel.userResult?.username.trimmingCharacters(in: .whitespaces).isEmpty ?? true ? .placeholder : [])
            }
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(userId: "me"))
            .preferredColorScheme(.dark)
            .environmentObject(profile)
    }
}

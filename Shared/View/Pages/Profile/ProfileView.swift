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
            ProfileSectionView(
                name: profileModel.userResult?.fullname,
                username: profileModel.userResult?.username,
                about: profileModel.userResult?.about,
                followers: profileModel.userResult?.followersCount,
                followings: profileModel.userResult?.followingsCount,
                avatar: profileModel.userResult?.avatarAddress,
                cover: profileModel.userResult?.coverAddress,
                profilePreviewAction: { profileModel.showAvatarPreview.toggle() },
                followersAction: {},
                followingsAction: {}
            )
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
            AvatarPreview(imageAddress: profileModel.userResult?.avatarAddress)
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
}

struct ProfileView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(userId: "1"))
            .environmentObject(profile)
    }
}

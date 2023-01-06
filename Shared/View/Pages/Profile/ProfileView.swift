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
                joinedDate: profileModel.userResult?.joinedDate,
                about: profileModel.userResult?.about,
                followers: profileModel.userResult?.followersCount,
                followings: profileModel.userResult?.followingsCount,
                tricksCount: profileModel.userResult?.tricksCount,
                avatar: profileModel.userResult?.avatarAddress,
                cover: profileModel.userResult?.coverAddress,
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

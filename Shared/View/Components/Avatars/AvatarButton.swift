//
//  AvatarButton.swift
//  Tricks
//
//  Created by Armin on 1/5/23.
//

import NukeUI
import SwiftUI

struct AvatarButton: View {
    
    var avatar: URL?
    var name:   String?
    var userID: String
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    var body: some View {
        NavigationButton(title: name ?? "") {
            ZStack {
                AvatarView(
                    avatar: avatar,
                    name: name
                )
                #if os(macOS)
                /// There is a bug in macOS SwiftUI that the Image is not make it clickable without this hack
                Color.white.opacity(0.001)
                #endif
            }
        } destination: {
            ProfileView(viewModel: ProfileViewModel(userId: userID))
                .environmentObject(profile)
        }
    }
}

struct AvatarButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AvatarButton(
                avatar: URL(string: "https://tricks.aseman.io/api/v1/storage/static/avatar_general.jpg"),
                name: "Test",
                userID: ""
            )
            .frame(width: 80, height: 80)
            .padding()
            
            AvatarButton(userID: "")
                .frame(width: 80, height: 80)
                .padding()
            
            AvatarButton(name: "A" ,userID: "")
                .frame(width: 80, height: 80)
                .padding()
        }
    }
}

//
//  AvatarView.swift
//  Tricks
//
//  Created by Armin on 11/11/22.
//

import SwiftUI
import NukeUI

struct AvatarView: View {
    
    @State var avatar: String
    @State var name:   String
    @State var userID: String
    @EnvironmentObject var profile: MyProfileViewModel
    
    var body: some View {
        NavigationButton(title: name) {
            ZStack {
                Circle()
                    .foregroundStyle(.white)
                
                LazyImage(source: avatar) { state in
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
                .padding(.all, 2)
            }
        } destination: {
            ProfileView(viewModel: ProfileViewModel(userId: userID))
                .environmentObject(profile)
        }
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(
            avatar: "https://tricks.aseman.io/api/v1/storage/static/avatar_general.jpg",
            name: "Test",
            userID: "test"
        )
        .frame(width: 50, height: 50)
    }
}

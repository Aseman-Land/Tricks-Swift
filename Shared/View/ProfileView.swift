//
//  ProfileView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @StateObject private var profileModel: ProfileViewModel
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    init(viewModel: @autoclosure @escaping () -> ProfileViewModel) {
        _profileModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                UserView()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .task {
            profileModel.profile = profile
            await profileModel.getProfile()
        }
    }
    
    @ViewBuilder
    func UserView() -> some View {
        VStack(spacing: 12) {
            // MARK: - User avatar
            ZStack {
                Circle()
                    .foregroundStyle(.white)
                    .frame(width: 80, height: 80)
                WebImage(url: URL(string: "https://\(AppService.apiKey)/api/v1/\(profileModel.avatar)"))
                    .resizable()
                    .placeholder {
                        Image(systemName: "person.fill")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .transition(.fade)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 75, height: 75, alignment: .center)
                    .padding(.all, 2)
            }
            .frame(width: 80, height: 80)
            .shadow(radius: 1)
            
            VStack {
                // MARK: - User's name
                Text(profileModel.fullname)
                    .font(.title)
                    .fontWeight(.medium)
                    .dynamicTypeSize(.xSmall ... .large)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                // MARK: - Username
                if profileModel.username != "" {
                    Text("@\(profileModel.username)")
                        .font(.body)
                        .fontWeight(.light)
                        .dynamicTypeSize(.xSmall ... .large)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(userId: "me"))
            .environmentObject(profile)
    }
}

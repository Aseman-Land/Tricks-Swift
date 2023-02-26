//
//  TrickUserInfo.swift
//  Tricks
//
//  Created by Armin on 4/5/22.
//

import NukeUI
import SwiftUI

struct TrickUserInfo: View {
    
    @Binding var trick: Trick
    @EnvironmentObject var profile: MyProfileViewModel
    
    var body: some View {
        HStack {
            // MARK: - User avatar
            UserRow(
                name: trick.owner.fullname,
                username: trick.owner.username,
                userID: String(trick.owner.id),
                language: trick.programing_language?.name
            )
            .environmentObject(profile)

            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                // MARK: - Trick's time
                Text(trick.date, style: .relative)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
                    .dynamicTypeSize(.xSmall ... .medium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                
                // MARK: - View count
                HStack(spacing: 5) {
                    Image(systemName: "eye")
                    Text(trick.views, format: .number.notation(.compactName))
                }
                .font(.caption.weight(.light))
            }
            .foregroundStyle(.secondary)
        }
        .padding(.bottom, 8)
        .dynamicTypeSize(.xSmall ... .medium)
    }
}

struct UserRow: View {
    
    @State var name: String
    @State var username: String
    @State var userID: String
    @State var language: String?

    @EnvironmentObject var profile: MyProfileViewModel
    
    var body: some View {
        NavigationButton(title: name) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        // MARK: - Fullname
                        Text(name)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                            .dynamicTypeSize(.xSmall ... .medium)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                        
                        // MARK: - Username
                        Text("@\(username)")
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundStyle(.secondary)
                            .dynamicTypeSize(.xSmall ... .medium)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                    }
                    
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                        Text(language?.capitalized ?? "")
                    }
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .dynamicTypeSize(.xSmall ... .medium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .opacity(language != nil ? 1 : 0)
                }
            }
        } destination: {
            ProfileView(viewModel: ProfileViewModel(userId: userID))
                .environmentObject(profile)
        }
    }
}

struct TrickUserPreview_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        TrickUserInfo(trick: .constant(Trick.mockExample))
            .environmentObject(profile)
            .padding()
    }
}

//
//  ProfileSectionView.swift
//  Tricks
//
//  Created by Armin on 1/1/23.
//

import SwiftUI
import NukeUI
import Shimmer

struct ProfileSectionView: View {
    
    /// Details
    var name: String?
    var username: String?
    var joinedDate: Date?
    var about: String?
    var followers: Int?
    var followings: Int?
    var tricksCount: Int?
    
    /// Images
    var avatar: URL?
    var cover:  URL?
    
    /// Actions
    var followersAction: () -> Void
    var followingsAction: () -> Void
    
    #if os(iOS)
    var backgroundColor: Color {
        Color(UIColor.systemBackground)
    }
    #elseif os(macOS)
    var backgroundColor: Color {
        Color(.controlBackgroundColor)
    }
    #endif
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            /// Avatar and Cover
            ZStack(alignment: .bottomLeading) {
                /// Cover
                Group {
                    if let cover {
                        LazyImage(url: cover) { state in
                            if let image = state.image {
                                image
                                    .frame(height: 120)
                            } else {
                                Rectangle()
                                    .fill(.gray)
                                    .shimmering()
                            }
                        }
                    } else {
                        Image("cover_pattern")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .clipShape(Rectangle())
                .clipped()
                
                LinearGradient(
                    colors: [.clear, .clear, .clear, .clear, .clear, backgroundColor],
                    startPoint: .top,
                    endPoint: .bottom
                )
                    
                /// User avatar
                ZStack {
                    Circle()
                        .foregroundStyle(.ultraThinMaterial)
                        .shadow(radius: 2)
                    
                    NavigationButton(
                        title: name ?? "",
                        type: .fullCover
                    ) {
                        ZStack {
                            AvatarView(
                                avatar: avatar,
                                name: name,
                                placeholderFont: .largeTitle
                            )
                            #if os(macOS)
                            /// There is a bug in macOS SwiftUI that the Image is not make it clickable without this hack
                            Color.white.opacity(0.001)
                            #endif
                        }
                    } destination: {
                        AvatarPreview(imageAddress: avatar)
                    }
                    .frame(width: 70, height: 70, alignment: .center)
                }
                .frame(width: 80, height: 80, alignment: .center)
                .padding(5)
                .offset(y: 40)
                .padding(.horizontal, 15)
            }
            .padding(.bottom, 40)
            
            /// User details
            VStack(alignment: .leading, spacing: 6) {
                /// Name and Username
                VStack(alignment: .leading, spacing: 0) {
                    /// User's name
                    Text(name ?? "       ")
                        .font(.title2)
                        .fontWeight(.bold)
                        .dynamicTypeSize(.xSmall ... .large)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .redacted(reason: name?.trimmingCharacters(in: .whitespaces).isEmpty ?? true ? .placeholder : [])
                        .shimmering(active: name?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
                    
                    /// Username
                    Text("@" + (username ?? "     "))
                        .font(.body)
                        .dynamicTypeSize(.xSmall ... .large)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(.secondary)
                        .redacted(reason: username?.trimmingCharacters(in: .whitespaces).isEmpty ?? true ? .placeholder : [])
                        .shimmering(active: username?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    /// About
                    Text(about ?? "")
                        .font(.body)
                        .fontWeight(.light)
                        .dynamicTypeSize(.xSmall ... .large)
                        .hidden(about?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
                    
                    Label(
                        "Joined \(joinedDate?.formatted(date: .abbreviated, time: .omitted) ?? "")",
                        systemImage: "calendar"
                    )
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .labelStyle(.titleAndIcon)
                    .redacted(reason: joinedDate == nil ? .placeholder : [])
                    .shimmering(active: joinedDate == nil)
                    
                    /// Followings, Followers, Tricks counts
                    HStack(spacing: 15) {
                        Button(action: {}) {
                            Text("**\((followings ?? 0).formatted())** Following")
                                .redacted(reason: followings == nil ? .placeholder : [])
                                .shimmering(active: followings == nil)
                        }
                        
                        Button(action: {}) {
                            Text("**\((followers ?? 0).formatted())** Followers")
                                .redacted(reason: followers == nil ? .placeholder : [])
                                .shimmering(active: followers == nil)
                        }
                        
                        Text("**\((tricksCount ?? 0).formatted())** Tricks")
                            .redacted(reason: tricksCount == nil ? .placeholder : [])
                            .shimmering(active: tricksCount == nil)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom)
        .dynamicTypeSize(.xSmall ... .medium)
    }
}

struct ProfileSectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ProfileSectionView(
                name: "Armin",
                username: "Shalchian",
                joinedDate: Date(),
                about: "Something big to make it really make sense",
                followers: 999_990,
                followings: 120,
                tricksCount: 120,
                avatar: URL(string: "https://avatars.githubusercontent.com/u/4667751?v=4"),
                cover: URL(string: "https://www.apple.com/v/macos/ventura/a/images/router/compatible_devices__d5lgp6ypklua_large_2x.jpg"),
                followersAction: {},
                followingsAction: {}
            )
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
    }
}

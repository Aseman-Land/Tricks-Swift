//
//  NotificationRow.swift
//  Tricks
//
//  Created by Armin on 4/19/22.
//

import SwiftUI
import NukeUI

struct NotificationRow: View {
    
    var notif: Notif
    
    var notifBody: String {
        if let comment = notif.comment {
            return comment.message ?? ""
        } else {
            return notif.trick?.body ?? ""
        }
    }
    
    var body: some View {
        HStack {
            // Profile avatar and notification status
            AvatarButton(
                avatar: notif.user.avatarAddress,
                name: notif.user.fullname,
                userID: String(notif.user.id)
            )
            .frame(width: 40, height: 40)
            .overlay(alignment: .bottomTrailing) {
                Group {
                    switch notif.notifyType {
                    case 1:
                        // Like
                        Image(systemName: "heart.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .red)
                            .offset(x: 3, y: 3)
                    case 2:
                        // Follow
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .offset(x: 3, y: 3)
                    case 3:
                        // Comment
                        Image(systemName: "text.bubble.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .blue)
                            .offset(x: 5, y: 5)
                    default:
                        Spacer()
                    }
                }
            }
            .padding(.trailing, 10)
            
            // Notification Message
            VStack(alignment: .leading) {
                Group {
                    switch notif.notifyType {
                    case 1:
                        Text("**\(notif.user.fullname)** Liked your trick")
                    case 2:
                        Text("**\(notif.user.fullname)** Followed you")
                    case 3:
                        Text("**\(notif.user.fullname)** commented on your trick")
                    default:
                        Text("You have a notification")
                    }
                    
                }
                .font(.body)
                .foregroundStyle(.primary)
                .dynamicTypeSize(.xSmall ... .medium)
                .minimumScaleFactor(0.4)
                
                // Trick body caption
                Text(notifBody)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .dynamicTypeSize(.xSmall ... .medium)
                    .lineLimit(2)
            }
        }
    }
}

struct NotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NotificationRow(notif: .placeHolder(type: .like))
            NotificationRow(notif: .placeHolder(type: .follow))
            NotificationRow(notif: .placeHolder(type: .comment))
            NotificationRow(notif: .placeHolder(type: .mention))
            NotificationRow(notif: .placeHolder(type: .tagUpdate))
            NotificationRow(notif: .placeHolder(type: .tips))
            NotificationRow(notif: .placeHolder(type: .donate))
            NotificationRow(notif: .placeHolder(type: .unknown))
        }
        .navigationTitle("Notifications")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

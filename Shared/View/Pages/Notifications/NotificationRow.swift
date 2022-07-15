//
//  NotificationRow.swift
//  Tricks
//
//  Created by Armin on 4/19/22.
//

import SwiftUI
import NukeUI

struct NotificationRow: View {
    
    @State var notif: Notif
    
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
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                    LazyImage(source: notif.user.avatarAddress) { state in
                        if let image = state.image {
                            image
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.fill")
                                .font(.body)
                                .foregroundColor(.gray)
                                .clipShape(Circle())
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 38, height: 38, alignment: .center)
                    .padding(.all, 2)
                }
                .frame(width: 40, height: 40)
                .padding(.all , 10)
                .shadow(radius: 1)
                
                switch notif.notifyType {
                case 1:
                    // Like
                    Image(systemName: "heart.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .red)
                case 2:
                    // Quote
                    Image(systemName: "quote.bubble.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .indigo)
                case 3:
                    // Comment
                    Image(systemName: "text.bubble.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .green)
                default:
                    Spacer()
                }
            }
            .frame(width: 50, height: 50)
            .padding(.trailing, 10)
            
            // Notification Message
            VStack(alignment: .leading) {
                Group {
                    switch notif.notifyType {
                    case 1:
                        Text("**\(notif.user.fullname)** Liked your trick")
                    case 2:
                        Text("**\(notif.user.fullname)** quoted your trick")
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
        NavigationView {
            List {
                NotificationRow(notif: Notif.mockLikeExample)
                NotificationRow(notif: Notif.mockQuoteExample)
                NotificationRow(notif: Notif.mockCommentExample)
            }
            .navigationTitle("Notifications")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

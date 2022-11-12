//
//  NotificationsListView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI

struct NotificationsListView: View {
    
    @StateObject var notifModel: NotificationsViewModel = NotificationsViewModel()
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            switch notifModel.listStatus {
                
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                
            case .fullList:
                List {
                    ForEach(notifModel.notifs, id: \.id) { notif in
                        NotificationRow(notif: notif)
                    }
                }
                #if os(macOS)
                .environment(\.defaultMinListRowHeight, 60)
                .listStyle(.inset(alternatesRowBackgrounds: true))
                
                #endif
                .refreshable {
                    await notifModel.getNotifications()
                }
                
            case .emptyList:
                NoNotificationsView()
                
            case .errorLoading(let message):
                NetworkErrorView(title: message) {
                    Task.init {
                        await notifModel.getNotifications()
                    }
                }
            }
        }
        .task {
            notifModel.profile = profile
            await notifModel.getNotifications()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.UpdateNotifList)) { _ in
            Task.init {
                await notifModel.getNotifications()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #elseif os(macOS)
        .background(
            VisualEffectBlur(
                material: .contentBackground,
                blendingMode: .withinWindow
            )
        )
        #endif
    }
}

struct NotificationsListView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        NotificationsListView()
            .navigationTitle("Notifications")
            .environmentObject(profile)
            .navigationViewStyle(.columns)
    }
}

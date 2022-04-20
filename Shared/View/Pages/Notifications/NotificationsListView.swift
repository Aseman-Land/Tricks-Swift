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
                .refreshable {
                    await notifModel.getNotifications()
                }
                
            case .emptyList:
                EmptyList()
                
            case .errorLoading(let message):
                NetworkError(title: message) {
                    Task.init {
                        await notifModel.getNotifications()
                    }
                }
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task {
            notifModel.profile = profile
            await notifModel.getNotifications()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.UpdateNotifList)) { _ in
            Task.init {
                await notifModel.getNotifications()
            }
        }
    }
    
    // MARK: - Empty View
    @ViewBuilder
    func EmptyList() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "eyes.inverse")
                .font(.custom("system", size: 150))
            
            Text("Great, No Notification!")
                .font(.title)
                .fontWeight(.medium)
        }
        .dynamicTypeSize(.xSmall ... .medium)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .foregroundStyle(.secondary)
    }
    
    func NetworkError(title: String, action: @escaping () -> Void) -> some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "network")
                    .font(.custom("system", size: 150))
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
            }
            
            Text(title)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Text("Try again")
            }
            .buttonStyle(.bordered)
        }
        .foregroundStyle(.secondary)
    }
}

struct NotificationsListView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        NavigationView {
            NotificationsListView()
                .navigationTitle("Notifications")
                .environmentObject(profile)
        }
    }
}
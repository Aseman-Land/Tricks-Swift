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
                EmptyList()
                
            case .errorLoading(let message):
                NetworkError(title: message) {
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
    
    // MARK: - Empty View
    @ViewBuilder
    func EmptyList() -> some View {
        VStack(spacing: 12) {
            ZStack {
                Image(systemName: "bell.fill")
                    .font(.custom("system", size: 150))
                    .foregroundColor(.yellow)
                
                Image(systemName: "eyes.inverse")
                    .font(.custom("system", size: 50))
                    .foregroundColor(.white)
            }
            .opacity(0.60)
            
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
            Image(systemName: "pc")
                .font(.custom("system", size: 150))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .blue)
                .shadow(color: .black, radius: 2, x: 1, y: 1)
                .opacity(0.60)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Text("Try again")
            }
            .buttonStyle(.bordered)
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal)
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

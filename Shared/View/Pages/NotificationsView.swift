//
//  NotificationsView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        ZStack {
            EmptyList()
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(macOS)
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
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

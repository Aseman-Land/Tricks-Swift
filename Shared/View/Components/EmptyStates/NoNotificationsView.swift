//
//  NoNotificationsView.swift
//  Tricks
//
//  Created by Armin on 11/12/22.
//

import SwiftUI

struct NoNotificationsView: View {
    var body: some View {
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
}

struct NoNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NoNotificationsView()
            .padding()
    }
}

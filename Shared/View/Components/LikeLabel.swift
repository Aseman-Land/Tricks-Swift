//
//  LikeButton.swift
//  Tricks
//
//  Created by Armin on 11/10/22.
//

import SwiftUI

struct LikeLabel: View {
    
    @Binding var state: Bool
    
    var body: some View {
        Image(systemName: "hand.thumbsup.fill")
            .rotationEffect(.degrees(state ? 10 : 0), anchor: .bottomLeading)
            .animation(
                .interpolatingSpring(stiffness: 500, damping: 6).delay(0.15),
                value: state
            )
            .foregroundColor(state ? .red : .gray)
    }
}

struct LikeLabel_Previews: PreviewProvider {
    struct Preview: View {
        @State private var state: Bool = false
        
        var body: some View {
            Button {
                state.toggle()
            } label: {
                LikeLabel(state: $state)
            }
            .buttonStyle(.plain)
            .font(.largeTitle)
            .padding()
        }
    }
    static var previews: some View {
        Preview()
    }
}

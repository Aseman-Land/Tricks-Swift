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
        ZStack {
            Image(systemName: "hand.thumbsup.fill")
                .rotationEffect(.degrees(state ? 10 : 0), anchor: .bottomLeading)
                .animation(
                    .interpolatingSpring(stiffness: 170, damping: 6).delay(0.15),
                    value: state
                )
            
            Circle()
                .strokeBorder(lineWidth: state ? 0 : 25)
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundColor(.teal)
                .scaleEffect(state ? 1.1 : 0)
                .rotationEffect(.degrees(state ? 150 : 0))
                .opacity(state ? 0.8 : 0)
                .animation(.easeInOut(duration: 1).delay(0.17), value: state)
                .zIndex(2)
            
            Circle()
                .strokeBorder(style: StrokeStyle(
                    lineWidth: state ? 0 : 50,
                    lineCap: .butt,
                    dash: [3, 10]
                ))
                .frame(width: 75, height: 75, alignment: .center)
                .foregroundColor(.blue)
                .scaleEffect(state ? 1.2 : 0)
                .rotationEffect(.degrees(state ? 0 : -120))
                .hueRotation(.degrees(state ? 0 : 45))
                .opacity(state ? 0.8: 0)
                .animation(.easeInOut(duration: 1).delay(0.19).speed(1), value: state)
                .zIndex(3)
        }
        .foregroundColor(state ? .red : .gray)
        .frame(maxHeight: 40)
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
        }
    }
    static var previews: some View {
        Preview()
    }
}

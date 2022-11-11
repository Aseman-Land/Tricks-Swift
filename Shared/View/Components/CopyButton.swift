//
//  CopyLabel.swift
//  Tricks
//
//  Created by Armin on 11/11/22.
//

import SwiftUI

struct CopyButton: View {
    
    @State var action: () -> Void
    @State private var state: Bool = false
    
    var body: some View {
        ZStack {
            Image(systemName: "doc.fill")
                .offset(x: -2, y: 2)
                .offset(y: state ? -5 : 0)
                .animation(
                    .interpolatingSpring(stiffness: 170, damping: 6).delay(0.15),
                    value: state
                )
            
            Image(systemName: "doc")
                .offset(x: 2, y: -2)
                .offset(y: state ? -5 : 0)
                .animation(
                    .interpolatingSpring(stiffness: 170, damping: 6).delay(0.3),
                    value: state
                )
        }
        .onTapGesture {
            action()
            state = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                state = false
            }
        }
    }
}

struct CopyButton_Previews: PreviewProvider {
    static var previews: some View {
        CopyButton(action: {})
    }
}

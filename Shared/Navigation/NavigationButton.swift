//
//  NavigationButton.swift
//  Tricks
//
//  Created by Armin on 4/4/22.
//

import SwiftUI

struct NavigationButton<Content, Destination> : View where Content : View, Destination : View {
    let title: String
    let content: () -> Content
    let destination: () -> Destination
    
    var body: some View {
        #if os(iOS)
        ZStack(alignment: .leading) {
            NavigationLink(destination: destination) {
                EmptyView()
            }
            .opacity(0)
            
            content()
        }
        #elseif os(macOS)
        Button(action: {
            destination()
                .frame(minWidth: 450, minHeight: 650)
                .openInWindow(title: title, sender: self)
        }) {
            content()
        }
        .buttonStyle(.plain)
        #endif
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationButton(title: "Hello") {
                Text("Hello")
            } destination: {
                Text("Hello next")
            }

        }
    }
}

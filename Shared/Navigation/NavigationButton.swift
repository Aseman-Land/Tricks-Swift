//
//  NavigationButton.swift
//  Tricks
//
//  Created by Armin on 4/4/22.
//

import SwiftUI

enum NavigationType {
    case navigation
    case fullCover
}

struct NavigationButton<Content, Destination> : View where Content : View, Destination : View {
    
    public init(
        title: String,
        type: NavigationType = .navigation,
        content: @escaping () -> Content,
        destination: @escaping () -> Destination
    ) {
        self.title = title
        self.type = type
        self.content = content
        self.destination = destination
    }
    
    let title: String
    let type: NavigationType
    let content: () -> Content
    let destination: () -> Destination
    
    @State private var isDestinationPresented = false
    @State private var isFullCoverPresented   = false
    
    var body: some View {
        #if os(iOS)
        ZStack(alignment: .leading) {
            content()
                .onTapGesture {
                    switch type {
                    case .navigation:
                        self.isDestinationPresented = true
                    case .fullCover:
                        self.isFullCoverPresented = true
                    }
                }
                .fullScreenCover(isPresented: $isFullCoverPresented) {
                    destination()
                }
            
            NavigationLink(
                destination: destination(),
                isActive:self.$isDestinationPresented
            ) {
                EmptyView()
            }
            .opacity(0)
            .disabled(true)
        }
        #elseif os(macOS)
        Button(action: {
            destination()
                .frame(minWidth: 450, minHeight: 650)
                .openInWindow(
                    title: title,
                    sender: self,
                    transparentTitlebar: type == .fullCover
                )
        }) {
            content()
        }
        .buttonStyle(.plain)
        #endif
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                NavigationButton(title: "Hello", type: .navigation) {
                    Text("Hello")
                } destination: {
                    Text("Hello next")
                }
            }
            
            NavigationView {
                NavigationButton(title: "Hello", type: .fullCover) {
                    Text("Hello")
                } destination: {
                    Text("Hello next")
                }
            }
        }
    }
}

//
//  LoaderButton.swift
//  Tricks
//
//  Created by Armin on 4/4/22.
//

import SwiftUI

struct LoaderButton<Content: View>: View {
    
    @Binding var loading: Bool
    let content: () -> Content
    @State var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            if !loading {
                Button(action: action) {
                    content()
                }
                #if os(macOS)
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
                #endif
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    #if os(macOS)
                    .scaleEffect(0.5)
                    #endif
            }
        }
    }
}

struct LoaderButton_Previews: PreviewProvider {
    struct Preview: View {
        @State private var state: Bool = false
        
        var body: some View {
            LoaderButton(loading: $state) {
                Text("Hello")
            } action: {
                state.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    state.toggle()
                }
            }
        }
    }
    static var previews: some View {
        Preview()
    }
}

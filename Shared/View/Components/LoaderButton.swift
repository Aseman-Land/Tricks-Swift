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
            }
        }
    }
}

struct LoaderButton_Previews: PreviewProvider {
    static var previews: some View {
        LoaderButton(loading: .constant(false)) {
            Text("Hello")
        } action: {
            
        }
    }
}

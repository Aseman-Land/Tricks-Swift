//
//  LoaderButton.swift
//  Tricks
//
//  Created by Armin on 4/4/22.
//

import SwiftUI

struct LoaderButton: View {
    
    @State var title: String
    @Binding var loading: Bool
    @State var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            if !loading {
                Button("Send") {
                    action()
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
        LoaderButton(title: "Test", loading: .constant(false), action: {})
    }
}

//
//  AvatarPreview.swift
//  Tricks
//
//  Created by Armin on 4/24/22.
//

import SwiftUI
import NukeUI

struct AvatarPreview: View {
    
    @State var imageAddress: String
    @GestureState var scale: CGFloat = 1.0
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            #if os(macOS)
            VisualEffectBlur(
                material: .popover,
                blendingMode: .behindWindow
            )
            #endif
            
            LazyImage(source: imageAddress) { state in
                if state.isLoading {
                    if state.progress.total > 0 {
                    ProgressView(value: Float(state.progress.completed / state.progress.total))
                    }
                } else if let image = state.image {
                    ImagePreviewerView {
                        image
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Image(systemName: "person.fill")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            .priority(.high)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .updating($scale, body: { (value, scale, trans) in
                        scale = max(value.magnitude, 1.0)
                    })
            )
            
            #if os(iOS)
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(.title))
            }
            .padding()
            #endif
        }
        #if os(iOS)
        .background(Color.black)
        #elseif os(macOS)
        .edgesIgnoringSafeArea(.all)
        #endif
        .preferredColorScheme(.dark)
    }
}

struct AvatarPreview_Previews: PreviewProvider {
    static var previews: some View {
        AvatarPreview(
            imageAddress: "https://tricks.aseman.io/static/images/icon.png"
        )
    }
}

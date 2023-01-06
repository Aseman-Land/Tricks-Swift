//
//  TrickCodeImagePreview.swift
//  Tricks
//
//  Created by Armin on 4/5/22.
//

import SwiftUI
import NukeUI
import Shimmer

struct TrickCodeImagePreview: View {
    
    @State var url: URL?
    
    @State var codePreviewSize: CodePreviewDetail
    @State var width: CGFloat
    
    @StateObject private var image = FetchImage()
    
    var widthNormal: CGFloat {
        if width >= 450 {
            return 450
        } else {
            return width
        }
    }
    
    var height: CGFloat {
        widthNormal * CGFloat(codePreviewSize.height) / CGFloat(codePreviewSize.width)
    }
    
    var body: some View {
        VStack {
            // MARK: - Trick Image Preview
            if let content = image.view {
                content
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } else {
             RoundedRectangle(cornerRadius: 12)
                    .frame(height: height)
                    .shimmering()
            }
        }
        .frame(maxWidth: 450)
        .onAppear { image.load(url) }
        .onChange(of: url) { image.load($0) }
        .onDisappear { image.reset() }
    }
}

struct TrickCodeImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            TrickCodeImagePreview(
                url: Trick.mockExample.previewURL,
                codePreviewSize: Trick.mockExample.image_size ?? CodePreviewDetail(width: 300, height: 300),
                width: proxy.size.width
            )
        }
        .padding()
    }
}

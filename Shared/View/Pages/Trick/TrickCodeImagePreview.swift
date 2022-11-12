//
//  TrickCodeImagePreview.swift
//  Tricks
//
//  Created by Armin on 4/5/22.
//

import SwiftUI
import NukeUI

struct TrickCodeImagePreview: View {
    
    @State var url: URL?
    
    @State var codePreviewSize: CodePreviewDetail
    @State var width: CGFloat
    
    var widthNormal: CGFloat {
        if width >= 450 {
            return 450
        } else {
            return width
        }
    }
    
    var body: some View {
        VStack {
            // MARK: - Trick Image Preview
            #if os(macOS)
            LazyImage(url: url)
                .frame(height: widthNormal * CGFloat(codePreviewSize.height) / CGFloat(codePreviewSize.width))
            #else
            LazyImage(url: url, resizingMode: .aspectFit)
                .frame(height: widthNormal * CGFloat(codePreviewSize.height) / CGFloat(codePreviewSize.width))
            
            #endif
        }
        .frame(maxWidth: 450)
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

//
//  TrickCodeImagePreview.swift
//  Tricks
//
//  Created by Armin on 4/5/22.
//

import SwiftUI
import NukeUI

struct TrickCodeImagePreview: View {
    
    @State var source: String
    
    @State var codePreviewSize: CodePreviewDetail
    @State var width: CGFloat
    
    @Binding var likeLabel: Int
    @Binding var liked: Bool
    @State var likeAction: () -> Void
    
    @State var quoteAction: () -> Void
    
    @State var shareAction: () -> Void
    
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
            LazyImage(source: source)
                .frame(height: widthNormal * CGFloat(codePreviewSize.height) / CGFloat(codePreviewSize.width))
            #else
            LazyImage(source: source, resizingMode: .aspectFit)
                .frame(height: widthNormal * CGFloat(codePreviewSize.height) / CGFloat(codePreviewSize.width))
            
            #endif
            
            // MARK: - Trick actions
            HStack {
                Spacer()
                
                Button(action: likeAction) {
                    Label(likeLabel.formatted(), systemImage: liked ? "heart.fill" : "heart")
                }
                .buttonStyle(.plain)
                .foregroundColor(liked ? .red : .gray)
                .accentColor(.clear)
                
                Spacer()
                
                Button(action: quoteAction) {
                    Label("Quote", systemImage: "quote.bubble")
                }
                .buttonStyle(.plain)
                .labelStyle(.iconOnly)
                .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: shareAction) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.plain)
                .labelStyle(.iconOnly)
                .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.vertical, 10)
        }
        .frame(maxWidth: 450)
    }
}

struct TrickCodeImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            TrickCodeImagePreview(
                source: Trick.mockExample.previewAddress,
                codePreviewSize: Trick.mockExample.image_size ?? CodePreviewDetail(width: 300, height: 300),
                width: proxy.size.width,
                likeLabel: .constant(Int(1)),
                liked: .constant(true),
                likeAction: {},
                quoteAction: {},
                shareAction: {}
            )
        }
        .padding()
    }
}

//
//  TrickActions.swift
//  Tricks
//
//  Created by Armin on 4/8/22.
//

import SwiftUI

struct TrickActions: View {
    
    @Binding var likeLabel: Int
    
    @Binding var liked: Bool
    
    @State var likeAction: () -> Void
    
    @State var quoteAction: () -> Void
    
    @State var shareAction: () -> Void
    
    @State var copyAction: () -> Void
    
    var body: some View {
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
            
            Button(action: copyAction) {
                Label("Copy Code", systemImage: "doc.on.doc")
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .foregroundColor(.gray)
            
            Spacer()
        }
    }
}

struct TrickActions_Previews: PreviewProvider {
    static var previews: some View {
        TrickActions(
            likeLabel: .constant(10),
            liked: .constant(true),
            likeAction: {},
            quoteAction: {},
            shareAction: {}, copyAction: {}
        )
    }
}

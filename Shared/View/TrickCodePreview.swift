//
//  TrickCodePreview.swift
//  Tricks
//
//  Created by Armin on 4/5/22.
//

import SwiftUI

struct TrickCodePreview: View {
    
    @State var code: String
    
    @Binding var likeLabel: Int
    @Binding var liked: Bool
    @State var likeAction: () -> Void
    
    @State var quoteAction: () -> Void
    
    @State var shareAction: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 12, height: 12)
                
                Circle()
                    .foregroundColor(.yellow)
                    .frame(width: 12, height: 12)
                
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 12, height: 12)
                
                Spacer()
            }
            .padding([.top, .leading, .trailing])
            
            Text(code)
                .textSelection(.enabled)
                .font(.system(.caption, design: .monospaced))
                .dynamicTypeSize(.xSmall ... .large)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Divider()
            
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
        .cornerRadius(12)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.black)
                .shadow(color: Color.secondary, radius: 5, x: 0, y: 0)
        )
    }
}

struct TrickCodePreview_Previews: PreviewProvider {
    static var previews: some View {
        TrickCodePreview(
            code: "var test = \"Hello\"",
            likeLabel: .constant(Int(1)),
            liked: .constant(true),
            likeAction: {},
            quoteAction: {},
            shareAction: {}
        )
        .padding()
    }
}

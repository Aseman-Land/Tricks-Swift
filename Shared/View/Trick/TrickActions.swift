//
//  TrickActions.swift
//  Tricks
//
//  Created by Armin on 4/8/22.
//

import SwiftUI

struct TrickActions: View {
    
    @State var trickID: Int
    
    @Binding var likeLabel: Int
    @Binding var liked: Bool
    @State var shareItems: [Any] = [""]
    
    @State var likeAction: () -> Void
    @State var copyAction: () -> Void
    
    @EnvironmentObject var addQuoteModel: AddQuoteViewModel
    
    @State var showShare: Bool = false
    
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
            
            Button(action: { addQuoteModel.showQuoteView.toggle() }) {
                Label("Quote", systemImage: "quote.bubble")
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .foregroundColor(.gray)
            .popover(isPresented: $addQuoteModel.showQuoteView) {
                AddQuoteView(trickID: trickID)
                    #if os(macOS)
                    .frame(minWidth: 250, minHeight: 250)
                    #endif
                    .environmentObject(addQuoteModel)
            }
            
            Spacer()
            
            Button(action: { showShare = true }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .foregroundColor(.gray)
            #if os(iOS)
            .sheet(isPresented: $showShare) {
                ShareSheet(items: shareItems)
            }
            #elseif os(macOS)
            .background(ShareSheet(isPresented: $showShare, items: shareItems))
            #endif
            
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
    
    @StateObject static var addQuoteModel = AddQuoteViewModel()
    
    static var previews: some View {
        TrickActions(
            trickID: 1,
            likeLabel: .constant(10),
            liked: .constant(true),
            likeAction: {},
            copyAction: {}
        )
        .environmentObject(addQuoteModel)
    }
}

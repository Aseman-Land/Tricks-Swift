//
//  TrickActions.swift
//  Tricks
//
//  Created by Armin on 4/8/22.
//

import SwiftUI

struct TrickActions: View {
    
    @EnvironmentObject var trickModel: TrickViewModel
    @EnvironmentObject var addQuoteModel: AddQuoteViewModel
    
    @State var showShare: Bool = false
    
    var body: some View {
        HStack {
            /// Rate - Like
            Button {
                Task.init {
                    #if os(iOS)
                    HapticGenerator.shared.soft()
                    #endif
                    await trickModel.toggleLike()
                }
            } label: {
                HStack {
                    LikeLabel(state: $trickModel.liked)
                        .frame(width: 15, height: 15)
                    
                    Text(trickModel.trick.rates, format: .number.notation(.compactName))
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(trickModel.liked ? .red : .gray)
            .accentColor(.clear)
            
            /// Quote - Retrick
            Button(action: { addQuoteModel.showQuoteView.toggle() }) {
                Label("Quote", systemImage: "quote.bubble")
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .foregroundColor(.gray)
            .padding(.horizontal)
            .popover(isPresented: $addQuoteModel.showQuoteView) {
                AddQuoteView(trickID: trickModel.trick.id)
                    .frame(minWidth: 300, minHeight: 250)
                    .environmentObject(addQuoteModel)
            }
            
            Spacer()
            
            /// Share
            Button(action: { showShare = true }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .foregroundColor(.gray)
            .padding(.horizontal)
            #if os(iOS)
            .sheet(isPresented: $showShare) {
                /// FIXME: There is a bug with shareSheet
                ShareSheet(items: trickModel.shareBody())
            }
            #elseif os(macOS)
            .background(ShareSheet(isPresented: $showShare, items: trickModel.shareBody()))
            #endif
            
            /// Copy code
            CopyButton(action: trickModel.copyCode)
                .foregroundColor(.gray)
            
            /// Delete Trick
            if trickModel.isMine {
                Button {
                    trickModel.willDelete = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .buttonStyle(.plain)
                .labelStyle(.iconOnly)
                .foregroundColor(.gray)
                .confirmationDialog(
                    "Are you sure to delete this trick?",
                    isPresented: $trickModel.willDelete,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                        Task.init {
                            await trickModel.deleteTrick()
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct TrickActions_Previews: PreviewProvider {
    
    @StateObject static var trickModel = TrickViewModel(trick: .placeHolder())
    @StateObject static var addQuoteModel = AddQuoteViewModel()
    
    static var previews: some View {
        TrickActions()
            .environmentObject(trickModel)
            .environmentObject(addQuoteModel)
    }
}

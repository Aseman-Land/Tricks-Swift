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
            Button {
                Task.init {
                    await trickModel.addLike()
                }
            } label: {
                Label($trickModel.trick.rates.wrappedValue.formatted(), systemImage: trickModel.liked ? "heart.fill" : "heart")
            }
            .buttonStyle(.plain)
            .foregroundColor(trickModel.liked ? .red : .gray)
            .accentColor(.clear)
            
            Spacer()
            
            Button(action: { addQuoteModel.showQuoteView.toggle() }) {
                Label("Quote", systemImage: "quote.bubble")
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .foregroundColor(.gray)
            .popover(isPresented: $addQuoteModel.showQuoteView) {
                AddQuoteView(trickID: trickModel.trick.id)
                    .frame(minWidth: 300, minHeight: 250)
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
                ShareSheet(items: trickModel.shareBody())
            }
            #elseif os(macOS)
            .background(ShareSheet(isPresented: $showShare, items: trickModel.shareBody()))
            #endif
            
            Spacer()
            
            Button(action: trickModel.copyCode) {
                Label("Copy Code", systemImage: "doc.on.doc")
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .foregroundColor(.gray)
            
            
            if trickModel.isMine {
                Spacer()
                
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
    }
}

struct TrickActions_Previews: PreviewProvider {
    
    @StateObject static var trickModel = TrickViewModel(trick: Trick.mockExample)
    @StateObject static var addQuoteModel = AddQuoteViewModel()
    
    static var previews: some View {
        TrickActions()
            .environmentObject(trickModel)
            .environmentObject(addQuoteModel)
    }
}

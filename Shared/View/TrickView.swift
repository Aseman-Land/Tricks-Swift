//
//  TrickView.swift
//  Tricks
//
//  Created by Armin on 3/1/22.
//

import SwiftUI
import NukeUI

struct TrickView: View {
    
    @StateObject private var trickModel: TrickViewModel
    
    @State var parentWidth: CGFloat
    
    @StateObject private var addQuoteModel = AddQuoteViewModel()
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    @State var showShare: Bool = false
    
    init(trick: Trick, parentWidth: CGFloat) {
        _trickModel = StateObject(wrappedValue: TrickViewModel(trick: trick))
        _parentWidth = State(wrappedValue: parentWidth)
    }
    
    var body: some View {
        VStack {
            TrickUserPreview(trick: $trickModel.trick)
                .environmentObject(profile)
                .padding(.bottom, 8)
            
            // MARK: - Trick's body (description)
            Text(trickModel.trick.body)
                .font(.body)
                .foregroundStyle(.primary)
                .dynamicTypeSize(.xSmall ... .medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - Trick preview
            TrickCodePreview(
                code: trickModel.trick.code,
                likeLabel: $trickModel.trick.rates,
                liked: $trickModel.liked) {
                    Task.init {
                        await trickModel.addLike()
                    }
                } quoteAction: {
                    addQuoteModel.showQuoteView.toggle()
                } shareAction: {
                    showShare = true
                }
                .popover(isPresented: $addQuoteModel.showQuoteView) {
                    AddQuoteView(trickID: trickModel.trick.id)
                        #if os(macOS)
                        .frame(minWidth: 250, minHeight: 250)
                        #endif
                        .environmentObject(addQuoteModel)
                }
                #if os(iOS)
                .sheet(isPresented: $showShare) {
                    ShareSheet(items: shareBody())
                }
                #elseif os(macOS)
                .background(ShareSheet(isPresented: $showShare, items: shareBody()))
                #endif
                
        }
        .task {
            trickModel.profile = profile
            addQuoteModel.profile = profile
        }
    }
    
    func shareBody() -> [Any] {
        return [
            trickModel.trick.body,
            trickModel.trick.code,
            "By \(trickModel.trick.owner.fullname)",
            URL(string: AppService().imageURL(url: trickModel.trick.filename))!
        ]
    }
}

struct TrickView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        GeometryReader { proxy in
            TrickView(trick: Trick.mockExample, parentWidth: proxy.size.width)
                .padding()
                .environmentObject(profile)
                .preferredColorScheme(.dark)
        }
    }
}

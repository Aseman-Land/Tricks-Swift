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
    
    init(trick: Trick, parentWidth: CGFloat) {
        _trickModel = StateObject(wrappedValue: TrickViewModel(trick: trick))
        _parentWidth = State(wrappedValue: parentWidth)
    }
    
    var body: some View {
        VStack {
            TrickUserPreview(trick: $trickModel.trick)
                .environmentObject(profile)
            
            // MARK: - Trick's body (description)
            Text(trickModel.trickQuoteBody)
                .font(.body)
                .foregroundStyle(.primary)
                .dynamicTypeSize(.xSmall ... .medium)
                .multilineTextAlignment(trickModel.trickQuoteBodyTextAlignment)
                .frame(
                    maxWidth: .infinity,
                    alignment: trickModel.trickQuoteBodyAlignment
                )
            
            if let quote = trickModel.trick.quote {
                SectionView {
                    VStack {
                        HStack {
                            UserRow(
                                name: quote.user.fullname ,
                                username: quote.user.username,
                                userID: String(quote.user.id),
                                avatar: quote.user.avatarAddress ?? ""
                            )
                            .environmentObject(profile)
                            
                            Spacer()
                        }
                        
                        Text(trickModel.trickBody)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .dynamicTypeSize(.xSmall ... .medium)
                            .multilineTextAlignment(trickModel.trickBodyTextAlignment)
                            .frame(
                                maxWidth: .infinity,
                                alignment: trickModel.trickBodyAlignment
                            )
                        
                        // MARK: - Trick preview
                        TrickCodeImagePreview(
                            source: trickModel.trick.previewAddress,
                            codePreviewSize: trickModel.trick.image_size!,
                            width: parentWidth
                        )
                    }
                    .padding()
                }
                
                
            } else {
                // MARK: - Trick preview
                TrickCodeImagePreview(
                    source: trickModel.trick.previewAddress,
                    codePreviewSize: trickModel.trick.image_size!,
                    width: parentWidth
                )
            }
            
            TrickActions()
                .environmentObject(trickModel)
                .environmentObject(addQuoteModel)
                .frame(maxWidth: 450)
        }
        .task {
            trickModel.profile = profile
            addQuoteModel.profile = profile
        }
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

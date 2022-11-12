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
        HStack(alignment: .top) {
            AvatarView(
                avatar: trickModel.trick.owner.avatarAddress,
                name: trickModel.trick.owner.fullname,
                userID: String(trickModel.trick.owner.id)
            )
            .environmentObject(profile)
            .frame(width: 40, height: 40)
            .shadow(radius: 1)
            .padding(.trailing, 5)
            
            VStack {
                TrickUserInfo(trick: $trickModel.trick)
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
                        HStack(alignment: .top) {
                            AvatarView(
                                avatar: quote.user.avatarAddress,
                                name: quote.user.fullname,
                                userID: String(quote.user.id)
                            )
                            .environmentObject(profile)
                            .frame(width: 40, height: 40)
                            .shadow(radius: 1)
                            .padding(.trailing)
                            
                            VStack {
                                HStack {
                                    UserRow(
                                        name: quote.user.fullname ,
                                        username: quote.user.username,
                                        userID: String(quote.user.id)
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
                                    url: trickModel.trick.previewURL,
                                    codePreviewSize: trickModel.trick.image_size!,
                                    width: parentWidth
                                )
                            }
                        }
                        .padding()
                    }
                    
                    
                } else {
                    // MARK: - Trick preview
                    TrickCodeImagePreview(
                        url: trickModel.trick.previewURL,
                        codePreviewSize: trickModel.trick.image_size!,
                        width: parentWidth
                    )
                }
                
                TrickActions()
                    .environmentObject(trickModel)
                    .environmentObject(addQuoteModel)
                    .frame(maxWidth: 450)
            }
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

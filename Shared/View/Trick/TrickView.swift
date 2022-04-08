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
            Text((trickModel.trick.quote != nil) ? (trickModel.trick.quote?.quote ?? "") : trickModel.trick.body)
                .font(.body)
                .foregroundStyle(.primary)
                .dynamicTypeSize(.xSmall ... .medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if trickModel.trick.quote != nil {
                SectionView {
                    VStack {
                        HStack {
                            UserRow(
                                name: trickModel.trick.quote?.user.fullname ?? "",
                                username: trickModel.trick.quote?.user.username ?? "",
                                userID: String(trickModel.trick.quote?.user.id ?? 1),
                                avatar: trickModel.trick.quote?.user.avatarAddress ?? ""
                            )
                            .environmentObject(profile)
                            
                            Spacer()
                        }
                        
                        Text(trickModel.trick.body)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .dynamicTypeSize(.xSmall ... .medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
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
                .padding(.horizontal)
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

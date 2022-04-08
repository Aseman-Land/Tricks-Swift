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
                        let _ = print(trickModel.trick.previewAddress)
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
            
            TrickActions(
                trickID: trickModel.trick.id,
                likeLabel: $trickModel.trick.rates,
                liked: $trickModel.liked,
                shareItems: shareBody()
            ) {
                Task.init {
                    await trickModel.addLike()
                }
            } copyAction: {
                copyCode(code: trickModel.trick.code)
            }
            .environmentObject(addQuoteModel)
            .frame(maxWidth: 450)
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
            URL(string: trickModel.trick.previewAddress)!
        ]
    }
    
    func copyCode(code: String) {
        #if os(iOS)
        let pasteboard = UIPasteboard.general
        pasteboard.string = code
        HapticGenerator.shared.success()
        #elseif os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(code, forType: .string)
        #endif
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

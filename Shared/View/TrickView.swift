//
//  TrickView.swift
//  Tricks
//
//  Created by Armin on 3/1/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct TrickView: View {
    
    @StateObject private var trickModel: TrickViewModel
    @StateObject private var addQuoteModel = AddQuoteViewModel()
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    @State var showShare: Bool = false
    
    init(trick: Trick) {
        _trickModel = StateObject(wrappedValue: TrickViewModel(trick: trick))
    }
    
    var body: some View {
        VStack {
            HStack {
                // MARK: - User avatar
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                    WebImage(url: trickModel.trickOwnerAvatar)
                        .resizable()
                        .placeholder {
                            Image(systemName: "person.fill")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .transition(.fade)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 38, height: 38, alignment: .center)
                        .padding(.all, 2)
                }
                .frame(width: 40, height: 40)
                .shadow(radius: 1)
                
                // MARK: - User info
                HStack {
                    NavigationButton(title: trickModel.trick.owner.fullname) {
                        VStack(alignment: .leading) {
                            // MARK: - Fullname
                            Text(trickModel.trick.owner.fullname)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                            
                            // MARK: - Username
                            Text("@\(trickModel.trick.owner.username)")
                                .font(.caption)
                                .fontWeight(.light)
                        }
                    } destination: {
                        ProfileView(viewModel: ProfileViewModel(userId: String(trickModel.trick.owner.id)))
                            .environmentObject(profile)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        // MARK: - Trick's time
                        Text(trickModel.trickDate, style: .relative)
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundStyle(.secondary)
                        
                        // MARK: - View count
                        Label(trickModel.trick.views.formatted(), systemImage: "eye")
                            .font(.caption.weight(.light))
                        
                    }
                    .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 8)
            
            // MARK: - Trick's body (description)
            Text(trickModel.trick.body)
                .font(.body)
                .foregroundStyle(.primary)
                .dynamicTypeSize(.xSmall ... .medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - Trick preview
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
                
                Text(trickModel.trick.code)
                    .textSelection(.enabled)
                    .font(.system(.caption, design: .monospaced))
                    .dynamicTypeSize(.xSmall ... .large)
                    .lineLimit(5)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Divider()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        Task.init {
                            await trickModel.addLike()
                        }
                    }) {
                        Label(trickModel.trick.rates.formatted(), systemImage: trickModel.liked ? "heart.fill" : "heart")
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(trickModel.liked ? .red : .gray)
                    .accentColor(.clear)
                    
                    Spacer()
                    
                    Button(action: {
                        addQuoteModel.showQuoteView.toggle()
                    }) {
                        Label("Quote", systemImage: "quote.bubble")
                    }
                    .buttonStyle(.plain)
                    .labelStyle(.iconOnly)
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: { showShare = true }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.plain)
                    .labelStyle(.iconOnly)
                    .foregroundColor(.gray)
                    #if os(iOS)
                    .sheet(isPresented: $showShare) {
                        ShareSheet(items: shareBody())
                    }
                    #elseif os(macOS)
                    .background(ShareSheet(isPresented: $showShare, items: shareBody()))
                    #endif
                    
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
            .popover(isPresented: $addQuoteModel.showQuoteView) {
                AddQuoteView(trickID: trickModel.trick.id)
                    #if os(macOS)
                    .frame(minWidth: 250, minHeight: 250)
                    #endif
                    .environmentObject(addQuoteModel)
            }
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
        TrickView(trick: Trick.mockExample)
            .padding()
            .environmentObject(profile)
            .preferredColorScheme(.dark)
    }
}

//
//  AvatarView.swift
//  Tricks
//
//  Created by Armin on 11/11/22.
//

import NukeUI
import SwiftUI

struct AvatarView: View {
    
    var avatar: URL?
    var name: String?
    var placeholderFont: Font.TextStyle = .title2
    
    var body: some View {
        LazyImage(url: avatar) { state in
            if let image = state.image {
                image
                    .aspectRatio(contentMode: .fill)
            } else {
                ZStack {
                    Color.accentColor
                    
                    if let char = name?.first?.uppercased() {
                        Text(char)
                            .font(.system(placeholderFont, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(placeholderFont, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .clipShape(Circle())
        .dynamicTypeSize(.small)
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AvatarView(
                avatar: URL(string: "https://tricks.aseman.io/api/v1/storage/static/avatar_general.jpg"),
                name: "Test"
            )
            .frame(width: 80, height: 80)
            .padding()
            
            AvatarView()
                .frame(width: 80, height: 80)
                .padding()
            
            AvatarView(name: "A")
                .frame(width: 80, height: 80)
                .padding()
        }
    }
}

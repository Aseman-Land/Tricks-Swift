//
//  AvatarPreview.swift
//  Tricks
//
//  Created by Armin on 4/24/22.
//

import SwiftUI
import NukeUI

struct AvatarPreview: View {
    
    @State var imageAddress: String
    
    var body: some View {
        LazyImage(source: imageAddress) { state in
            if state.isLoading {
                ProgressView(value: Float(state.progress.completed / state.progress.total))
            } else if let image = state.image {
                image
            } else {
                Image(systemName: "person.fill")
                    .font(.body)
                    .foregroundColor(.gray)
            }
        }
        .priority(.high)
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.all, 2)
    }
}

struct AvatarPreview_Previews: PreviewProvider {
    static var previews: some View {
        AvatarPreview(
            imageAddress: "https://tricks.aseman.io/static/images/icon.png"
        )
    }
}

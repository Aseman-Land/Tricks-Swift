//
//  GeneralSettingsView.swift
//  Tricks (macOS)
//
//  Created by Armin on 3/1/22.
//

import SwiftUI
import SDWebImage

struct GeneralSettingsView: View {
    var body: some View {
        Button(action: {
            SDWebImageManager.defaultImageCache?.clear(with: .all)
        }) {
            Text("Clear cache")
        }
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}

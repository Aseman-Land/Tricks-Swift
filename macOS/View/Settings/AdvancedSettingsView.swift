//
//  AdvancedSettingsView.swift
//  Tricks (macOS)
//
//  Created by Armin on 3/1/22.
//

import SwiftUI
import SDWebImage

struct AdvancedSettingsView: View {
    var body: some View {
        Form {
            HStack {
                Text("Reset downloaded images cache:")
                Button(action: {
                    SDWebImageManager.defaultImageCache?.clear(with: .all)
                }) {
                    Text("Reset cache")
                }
            }
        }
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView()
    }
}

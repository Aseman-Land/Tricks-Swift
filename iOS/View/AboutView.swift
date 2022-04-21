//
//  AboutView.swift
//  Tricks (iOS)
//
//  Created by Armin on 4/21/22.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Image("AppIconPreview")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(50.0)
                
                Text(Bundle.main.displayName ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                VStack(spacing: 8.0) {
                    Text("\(Bundle.main.displayName ?? "") \(Bundle.main.appVersion) (\(Bundle.main.appBundleVersion))")
                        .font(.caption)
                        .fontWeight(.light)
                }
                .padding()
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

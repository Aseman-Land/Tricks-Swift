//
//  NetworkErrorView.swift
//  Tricks
//
//  Created by Armin on 11/12/22.
//

import SwiftUI

struct NetworkErrorView: View {
    
    var title: String
    @State var action: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "pc")
                .font(.custom("system", size: 150))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .blue)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                .opacity(0.60)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Text("Try again")
            }
            .buttonStyle(.bordered)
        }
        .dynamicTypeSize(.xSmall ... .medium)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
    }
}

struct NetworkErrorView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkErrorView(title: "Network error", action: {})
            .padding()
    }
}

//
//  EmptyListView.swift
//  Tricks
//
//  Created by Armin on 11/12/22.
//

import SwiftUI

struct EmptyListView: View {
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "macwindow")
                    .font(.custom("system", size: 150))
                    .symbolRenderingMode(.multicolor)
                
                Text("404")
                    .font(.system(.largeTitle, design: .monospaced))
                    .offset(y: 15)
            }
            
            Text("No tricks available")
                .font(.title)
                .fontWeight(.medium)
        }
        .dynamicTypeSize(.xSmall ... .medium)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .foregroundStyle(.secondary)
        .opacity(0.75)
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
            .padding()
    }
}

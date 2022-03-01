//
//  TricksListView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI

struct TricksListView: View {
    var body: some View {
        EmptyList()
    }
    
    // MARK: - Empty View
    @ViewBuilder
    func EmptyList() -> some View {
        VStack {
            ZStack {
                Image(systemName: "macwindow")
                    .font(.custom("system", size: 150))
                
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
    }
}

struct TricksListView_Previews: PreviewProvider {
    static var previews: some View {
        TricksListView()
    }
}

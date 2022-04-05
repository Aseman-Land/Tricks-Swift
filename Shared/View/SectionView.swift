//
//  SectionView.swift
//  Tricks
//
//  Created by Armin on 4/6/22.
//

import SwiftUI

struct SectionView<Content: View>: View {
    var title: String? = nil
    let content: () -> Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(.secondary, style: StrokeStyle(lineWidth: 1))
                )
            
            VStack {
                if let title = title {
                    Text(title)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                }
                
                content()
            }
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView {
            Text("Hello")
        }
        .padding()
    }
}

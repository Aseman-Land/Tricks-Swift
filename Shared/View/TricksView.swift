//
//  TricksView.swift
//  Tricks
//
//  Created by Armin on 3/1/22.
//

import SwiftUI

struct TricksView: View {
    
    var trick: Trick
    
    var body: some View {
        VStack {
            HStack {
                // MARK: - User avatar
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    AsyncImage(url: URL(string: "https://\(AppService.apiKey)/api/v1/\(trick.owner.avatar ?? "")")) { phase in
                        switch phase {
                        case .empty, .failure:
                            Image(systemName: "person.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.all, 2)
                }
                .frame(maxWidth: 40, maxHeight: 40)
                .shadow(radius: 1)
                
                VStack {
                    // MARK: - Fullname
                    Text(trick.owner.fullname)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: - Username
                    Text("@\(trick.owner.username)")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom)
            
            // MARK: - Trick's body (description)
            Text(trick.body)
                .font(.body)
                .foregroundStyle(.primary)
                .dynamicTypeSize(.xSmall ... .medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - Trick preview
            AsyncImage(url: URL(string: "https://\(AppService.apiKey)/api/v1/\(trick.filename ?? "")")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                case .failure:
                    ZStack {
                        Image(systemName: "macwindow")
                            .font(.custom("system", size: 120))
                            .foregroundStyle(.secondary)
                        
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                            .offset(y: 5)
                    }
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .padding(.all)
    }
}

struct TricksView_Previews: PreviewProvider {
    static var previews: some View {
        TricksView(trick: Trick.mockExample)
            .preferredColorScheme(.dark)
    }
}

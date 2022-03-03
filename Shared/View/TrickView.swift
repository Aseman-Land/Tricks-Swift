//
//  TrickView.swift
//  Tricks
//
//  Created by Armin on 3/1/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct TrickView: View {
    
    var trick: Trick
    
    private var trickDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: trick.datetime) ?? Date()
    }
    
    var body: some View {
        VStack {
            HStack {
                // MARK: - User avatar
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                    WebImage(url: URL(string: "https://\(AppService.apiKey)/api/v1/\(trick.owner.avatar ?? "")"))
                        .resizable()
                        .placeholder {
                            Image(systemName: "person.fill")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .transition(.fade)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 38, height: 38, alignment: .center)
                        .padding(.all, 2)
                }
                .frame(width: 40, height: 40)
                .shadow(radius: 1)
                
                // MARK: - User info
                VStack {
                    HStack {
                        // MARK: - Fullname
                        Text(trick.owner.fullname)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        // MARK: - Trick's time
                        Text(trickDate, style: .relative)
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundStyle(.secondary)
                    }
                    
                    // MARK: - Username
                    Text("@\(trick.owner.username)")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 8)
            
            // MARK: - Trick's body (description)
            Text(trick.body)
                .font(.body)
                .foregroundStyle(.primary)
                .dynamicTypeSize(.xSmall ... .medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - Trick preview
            VStack {
                HStack {
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 12, height: 12)
                    
                    Circle()
                        .foregroundColor(.yellow)
                        .frame(width: 12, height: 12)
                    
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 12, height: 12)
                    
                    Spacer()
                }
                .padding([.top, .leading, .trailing])
                
                Text(trick.code)
                    .textSelection(.enabled)
                    .font(.system(.caption, design: .monospaced))
                    .dynamicTypeSize(.xSmall ... .large)
                    .lineLimit(5)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(12)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.black)
                    .shadow(color: Color.secondary, radius: 5, x: 0, y: 0)
            )
        }
    }
}

struct TrickView_Previews: PreviewProvider {
    static var previews: some View {
        TrickView(trick: Trick.mockExample)
            .padding()
            .preferredColorScheme(.dark)
    }
}

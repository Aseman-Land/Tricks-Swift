//
//  TrickUserPreview.swift
//  Tricks
//
//  Created by Armin on 4/5/22.
//

import SwiftUI
import NukeUI

struct TrickUserPreview: View {
    
    @Binding var trick: Trick
    @EnvironmentObject var profile: MyProfileViewModel
    
    var trickDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: trick.datetime) ?? Date()
    }
    
    var body: some View {
        HStack {
            // MARK: - User avatar
            UserRow(
                name: trick.owner.fullname,
                username: trick.owner.username,
                userID: String(trick.owner.id),
                avatar: trick.owner.avatar ?? ""
            )
            .environmentObject(profile)

            Spacer()
            
            VStack(alignment: .trailing) {
                // MARK: - Trick's time
                Text(trickDate, style: .relative)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
                
                // MARK: - View count
                Label(trick.views.formatted(), systemImage: "eye")
                    .font(.caption.weight(.light))
                
            }
            .foregroundStyle(.secondary)
        }
        .padding(.bottom, 8)
    }
}

struct UserRow: View {
    
    @State var name: String
    @State var username: String
    @State var userID: String
    @State var avatar: String

    @EnvironmentObject var profile: MyProfileViewModel
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                LazyImage(source: "https://\(AppService.apiKey)/api/v1/\(avatar)") { state in
                    if let image = state.image {
                        image
                    } else {
                        Image(systemName: "person.fill")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 38, height: 38, alignment: .center)
                .padding(.all, 2)
            }
            .frame(width: 40, height: 40)
            .shadow(radius: 1)
            
            // MARK: - User info
            NavigationButton(title: name) {
                VStack(alignment: .leading) {
                    // MARK: - Fullname
                    Text(name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                    
                    // MARK: - Username
                    Text("@\(username)")
                        .font(.caption)
                        .fontWeight(.light)
                }
            } destination: {
                ProfileView(viewModel: ProfileViewModel(userId: userID))
                    .environmentObject(profile)
            }
        }
    }
}

struct TrickUserPreview_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        TrickUserPreview(trick: .constant(Trick.mockExample))
            .environmentObject(profile)
            .padding()
    }
}

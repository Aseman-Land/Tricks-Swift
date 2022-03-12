//
//  ProfileView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var profileModel: ProfileViewModel
    
    init(viewModel: @autoclosure @escaping () -> ProfileViewModel) {
        _profileModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                UserView()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    @ViewBuilder
    func UserView() -> some View {
        VStack(spacing: 12) {
            // MARK: - User avatar
            ZStack {
                Circle()
                    .stroke(.secondary)
                    .foregroundStyle(.secondary)
                
                AsyncImage(url: URL(string: "https://aseman.io/wp-content/uploads/2018/12/aseman-logo.png")) { phase in
                    switch phase {
                    case .empty, .failure:
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.all, 5)
            }
            .frame(maxWidth: 80, maxHeight: 80)
            
            VStack {
                // MARK: - User's name
                Text("Aseman")
                    .font(.title)
                    .fontWeight(.medium)
                    .dynamicTypeSize(.xSmall ... .large)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                // MARK: - Username
                Text("@aseman")
                    .font(.body)
                    .fontWeight(.light)
                    .dynamicTypeSize(.xSmall ... .large)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(userId: "me"))
    }
}

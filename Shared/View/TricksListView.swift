//
//  TricksListView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct TricksListView: View {
    
    @StateObject var tricksListModel: TricksListViewModel
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    init(viewModel: @autoclosure @escaping () -> TricksListViewModel) {
        _tricksListModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ZStack {
            if tricksListModel.errorMessage == "" {
                List {
                    ForEach(tricksListModel.tricks, id: \.id) { trick in
                        TrickView(trick: trick)
                            #if os(iOS)
                            .listSectionSeparator(.hidden)
                            .listRowSeparator(.hidden)
                            #elseif os(macOS)
                            .padding()
                            #endif
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await tricksListModel.loadTricks()
                }
                
                if tricksListModel.tricks.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                }
                
            } else if !tricksListModel.tricks.isEmpty {
                EmptyList()
            } else {
                NetworkError(title: tricksListModel.errorMessage) {
                    Task.init {
                        await tricksListModel.loadTricks()
                    }
                }
            }
        }
        .task {
            tricksListModel.profile = profile
            await tricksListModel.loadTricks()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.UpdateList)) { _ in
            Task.init {
                await tricksListModel.loadTricks()
            }
        }
    }
    
    // MARK: - Empty View
    private struct EmptyList: View {
        var body: some View {
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
    
    func NetworkError(title: String, action: @escaping () -> Void) -> some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "network")
                    .font(.custom("system", size: 150))
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
            }
            
            Text(title)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Text("Try again")
            }
            .buttonStyle(.bordered)
        }
        .foregroundStyle(.secondary)
    }
}

struct TricksListView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        TricksListView(viewModel: TricksListViewModel(.timeline))
            .environmentObject(profile)
    }
}

//
//  TricksListView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI

struct TricksListView<ProfileContent: View>: View {
    
    @StateObject var tricksListModel: TricksListViewModel
    
    let profileContent: ProfileContent
    
    @State var showAddTrick: Bool = false
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    init(
        viewModel: @autoclosure @escaping () -> TricksListViewModel,
        @ViewBuilder profileContent: () -> ProfileContent
    ) {
        _tricksListModel = StateObject(wrappedValue: viewModel())
        self.profileContent = profileContent()
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            switch tricksListModel.listStatus {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
            case .fullList:
                GeometryReader { proxy in
                    ScrollRefreshable {
                        LazyVStack {
                            profileContent
                            
                            ForEach(tricksListModel.tricks, id: \.id) { trick in
                                TrickView(trick: trick, parentWidth: proxy.size.width)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal)
                                    #if os(iOS)
                                    .padding(.bottom)
                                    #elseif os(macOS)
                                    .padding()
                                    #endif
                            }
                        }
                    } onRefresh: {
                        await tricksListModel.loadTricks()
                    }
                    .toolbar {
                        ToolbarItem {
                            #if os(macOS)
                            LoaderButton(loading: $tricksListModel.isRefreshing) {
                                Label("Refresh", systemImage: "arrow.clockwise")
                            } action: {
                                Task.init {
                                    tricksListModel.isRefreshing = true
                                    await tricksListModel.loadTricks()
                                }
                            }
                            #endif
                        }
                    }
                }
            case .emptyList:
                EmptyList()
            case .errorLoading(let message):
                NetworkError(title: message) {
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if tricksListModel.type == .timeline {
                    Button(action: { showAddTrick.toggle() }) {
                        Label("Add Trick", systemImage: "pencil")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddTrick) {
            AddTrickView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #elseif os(macOS)
        .background(
            VisualEffectBlur(
                material: .contentBackground,
                blendingMode: .withinWindow
            )
        )
        #endif
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

extension TricksListView where ProfileContent == EmptyView {
    init(viewModel: @autoclosure @escaping () -> TricksListViewModel) {
        self.init(viewModel: viewModel(), profileContent: { EmptyView() })
    }
}

struct TricksListView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        TricksListView(viewModel: TricksListViewModel(.timeline))
            .environmentObject(profile)
    }
}

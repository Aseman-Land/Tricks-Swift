//
//  TricksListView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI
import Refresh

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
                VStack {
                    profileContent
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    Spacer()
                }
            case .fullList:
                GeometryReader { proxy in
                    ScrollView {
                        RefreshHeader(
                            refreshing: $tricksListModel.isRefreshing,
                            action: {
                                Task.init {
                                    await tricksListModel.loadTricks()
                                }
                            }
                        ) { progress in
                            if tricksListModel.isRefreshing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                    #if os(macOS)
                                    .scaleEffect(0.5)
                                    #endif
                            } else {
                                Label("Pull to refresh", systemImage: "arrow.down")
                            }
                        }
                        
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
                        
                        RefreshFooter(
                            refreshing: $tricksListModel.isLoadingMore,
                            action: {
                                Task.init {
                                    await tricksListModel.loadMore()
                                }
                            }
                        ) {
                            if tricksListModel.noMore {
                                Text("\(tricksListModel.tricks.count.formatted())")
                            } else {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                    #if os(macOS)
                                    .scaleEffect(0.5)
                                    #endif
                            }
                        }
                        .noMore(tricksListModel.noMore)
                    }
                    .enableRefresh()
                }
            case .emptyList:
                VStack {
                    profileContent
                    Spacer()
                    EmptyList()
                    Spacer()
                }
            case .errorLoading(let message):
                VStack {
                    profileContent
                    Spacer()
                    NetworkError(title: message) {
                        Task.init {
                            await tricksListModel.loadTricks()
                        }
                    }
                    Spacer()
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
    
    func NetworkError(title: String, action: @escaping () -> Void) -> some View {
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
        .foregroundStyle(.secondary)
        .padding(.horizontal)
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

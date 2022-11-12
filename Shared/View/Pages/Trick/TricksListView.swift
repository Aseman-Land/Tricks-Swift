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
                                #if os(iOS)
                                HapticGenerator().soft()
                                #endif
                                Task.init {
                                    await tricksListModel.loadTricks()
                                }
                            }
                        ) { progress in
                            ZStack {
                                if tricksListModel.isRefreshing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                        #if os(macOS)
                                        .scaleEffect(0.5)
                                        #endif
                                } else {
                                    Label("Pull to refresh", systemImage: "arrow.down")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        
                        LazyVStack {
                            profileContent
                            
                            ForEach(tricksListModel.tricks, id: \.id) { trick in
                                TrickView(trick: trick, parentWidth: proxy.size.width)
                                    .fixedSize(horizontal: false, vertical: true)
                                    #if os(iOS)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                                    #elseif os(macOS)
                                    .padding()
                                    #endif
                            }
                        }
                        
                        RefreshFooter(
                            refreshing: $tricksListModel.isLoadingMore,
                            action: {
                                #if os(iOS)
                                HapticGenerator().soft()
                                #endif
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
                    EmptyListView()
                    Spacer()
                }
            case .errorLoading(let message):
                VStack {
                    profileContent
                    Spacer()
                    NetworkErrorView(title: message) {
                        Task.init {
                            await tricksListModel.loadTricks()
                        }
                    }
                    Spacer()
                }
            }
        }
        /// Loading tricks
        .task {
            tricksListModel.profile = profile
            await tricksListModel.loadTricks()
        }
        /// Updating list
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.UpdateList)) { _ in
            Task.init {
                await tricksListModel.loadTricks()
            }
        }
        .toolbar {
            /// Add trick item
            ToolbarItem(placement: .primaryAction) {
                if tricksListModel.type == .timeline {
                    Button(action: { showAddTrick.toggle() }) {
                        Label("Add Trick", systemImage: "pencil")
                    }
                }
            }
            #warning("Add refresher for macOS")
        }
        /// Add trick sheet
        .sheet(isPresented: $showAddTrick) {
            AddTrickView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #elseif os(macOS)
        /// Same Background as the List (for matching the same background)
        .background(
            VisualEffectBlur(
                material: .contentBackground,
                blendingMode: .withinWindow
            )
        )
        #endif
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

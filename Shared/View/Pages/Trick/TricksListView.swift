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
                List {
                    profileContent
                        #if os(iOS)
                        .listSectionSeparator(.hidden)
                        .listRowSeparator(.hidden)
                        #endif
                        .listRowInsets(EdgeInsets())
                }
                .listStyle(.plain)
                .overlay {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                }
            case .fullList:
                GeometryReader { proxy in
                    List {
                        /// Profile Section
                        profileContent
                            #if os(iOS)
                            .listSectionSeparator(.hidden)
                            .listRowSeparator(.hidden)
                            #endif
                            .listRowInsets(EdgeInsets())
                        
                        /// Tricks
                        ForEach(tricksListModel.tricks, id: \.id) { trick in
                            TrickView(trick: trick, parentWidth: proxy.size.width)
                                .fixedSize(horizontal: false, vertical: true)
                                #if os(iOS)
                                .listSectionSeparator(.hidden)
                                .listRowSeparator(.hidden)
                                #elseif os(macOS)
                                .padding([.horizontal, .bottom])
                                #endif
                        }
                        
                        /// Bottom pagination refresher
                        VStack {
                            if !tricksListModel.noMore {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                    #if os(macOS)
                                    .scaleEffect(0.5)
                                    #endif
                            } else {
                                Text("Total tricks: \(tricksListModel.tricks.count.formatted())")
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.secondary)
                                    .padding()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        #if os(iOS)
                        .listSectionSeparator(.hidden)
                        .listRowSeparator(.hidden)
                        #endif
                        .onAppear {
                            #if os(iOS)
                            HapticGenerator().soft()
                            #endif
                            Task.init {
                                if !tricksListModel.noMore {
                                    await tricksListModel.loadMore()
                                } else {
                                    print("No more!")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        #if os(iOS)
                        HapticGenerator().soft()
                        #endif
                        await tricksListModel.loadTricks()
                    }
                }
            case .emptyList:
                List {
                    profileContent
                        #if os(iOS)
                        .listSectionSeparator(.hidden)
                        .listRowSeparator(.hidden)
                        #endif
                }
                .listStyle(.plain)
                .overlay {
                    EmptyListView()
                }
            case .errorLoading(let message):
                List {
                    profileContent
                        #if os(iOS)
                        .listSectionSeparator(.hidden)
                        .listRowSeparator(.hidden)
                        #endif
                }
                .listStyle(.plain)
                .overlay {
                    NetworkErrorView(title: message) {
                        Task.init {
                            await tricksListModel.loadTricks()
                        }
                    }
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
            #if os(macOS)
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    Task.init {
                        await tricksListModel.loadTricks()
                    }
                }) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            #endif
        }
        /// Add trick sheet
        .sheet(isPresented: $showAddTrick) {
            AddTrickView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
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

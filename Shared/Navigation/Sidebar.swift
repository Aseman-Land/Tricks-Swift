//
//  Sidebar.swift
//  Tricks
//
//  Created by armin on 2/18/22.
//

import SwiftUI

struct Sidebar: View {

    @StateObject var viewModel = NavigationItemsModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.navigationItems) { item in
                    NavigationLink(
                        tag: item.id,
                        selection: $viewModel.selectedId
                    ) {
                        item.content
                            .navigationTitle(item.name)
                    } label: {
                        Label(item.name, systemImage: item.icon)
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("APP_NAME")
            .toolbar {
                #if os(macOS)
                ToolbarItemGroup {
                    Button(action: toggleSidebar) {
                        Image(systemName: "sidebar.leading")
                            .help("Toggle Sidebar")
                    }
                }
                #endif
            }
            .frame(minWidth: 150)
            Text("No selection")
        }
    }
    
    #if os(macOS)
    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    #endif
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}

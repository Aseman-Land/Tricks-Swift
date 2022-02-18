//
//  TabNavigation.swift
//  Tricks
//
//  Created by armin on 2/18/22.
//

import SwiftUI

struct TabNavigation: View {

    @StateObject var viewModel = NavigationItemsModel()

    var body: some View {
        TabView {
            ForEach(viewModel.navigationItems) { item in
                let menuText = Text(item.name)
                NavigationView {
                    item.content
                        .navigationTitle(item.name)
                }
                .tabItem {
                    Image(systemName: item.icon)
                        .accessibility(label: menuText)
                }
                .tag(item.id)
            }
        }
    }
}

struct TabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigation()
    }
}

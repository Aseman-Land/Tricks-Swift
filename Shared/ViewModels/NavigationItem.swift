//
//  NavigationItem.swift
//  Tricks
//
//  Created by armin on 2/18/22.
//

import SwiftUI

struct NavigationItem: Identifiable {
    let id = UUID().uuidString
    let name: LocalizedStringKey
    let comment: LocalizedStringKey
    let icon: String
    let content: AnyView
}

final class NavigationItemsModel: ObservableObject {
    
    @Published var navigationItems: [NavigationItem]
    @Published var selectedId: String?
    
    init(navigationItems: [NavigationItem] = NavigationItemsModel.defaultItems) {
        self.navigationItems = navigationItems
        self.selectedId = navigationItems[0].id
    }
    
    static let defaultItems: [NavigationItem] = [
        NavigationItem(
            name: "Home",
            comment: "Latest tricks",
            icon: "house",
            content: AnyView(TricksListView(viewModel: TricksListViewModel(.timeline)))
        ),
        NavigationItem(
            name: "Discover",
            comment: "Discover people's tricks",
            icon: "globe",
            content: AnyView(TricksListView(viewModel: TricksListViewModel(.global)))
        ),
        
        NavigationItem(
            name: "Notifications",
            comment: "Latest notifications",
            icon: "bell",
            content: AnyView(NotificationsListView())
        ),
        
        NavigationItem(
            name: "My Profile",
            comment: "Your profile",
            icon: "person",
            content: AnyView(ProfileView(viewModel: ProfileViewModel(userId: "me")))
        ),
    ]
}

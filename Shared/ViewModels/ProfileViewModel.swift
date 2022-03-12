//
//  ProfileViewModel.swift
//  Tricks
//
//  Created by Armin on 3/12/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
}

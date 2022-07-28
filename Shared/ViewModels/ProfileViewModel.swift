//
//  ProfileViewModel.swift
//  Tricks
//
//  Created by Armin on 3/12/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var userId: String
    
    @Published var profile: MyProfileViewModel? = nil
    
    @Published var userResult: UserResult? = nil
    
    @Published var showSettings: Bool = false
    @Published var showAvatarPreview: Bool = false
    
    private var service = UsersService()
    
    init(userId: String) {
        self.userId = userId
    }
    
    func getProfile() async {
        
        guard let token = profile?.userToken else { return }
        
        do {
            let result = try await service.getUser(userID: userId ,token: token)
            if result.status {
                DispatchQueue.main.async {
                    self.userResult = result.result
                }
            } else {
                print("Failed to get user data")
            }
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }
}

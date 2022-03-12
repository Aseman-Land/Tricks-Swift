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
    
    @Published var username: String = ""
    @Published var fullname: String = ""
    @Published var avatar: String = ""
    
    @Published var loading: Bool = false
    @Published var errorMessage: String = ""
    
    private var service = AuthService()
    
    init(userId: String) {
        self.userId = userId
    }
    
    func getProfile() async {
        
        guard let token = profile?.userToken else { return }
        
        Task(priority: .background) {
            let result = try await service.getUser(userID: userId ,token: token)
            
            switch result {
            case .success(let result):
                if result.status {
                    DispatchQueue.main.async {
                        self.username = result.result.username
                        self.fullname = result.result.fullname
                        
                        if let avatar = result.result.avatar {
                            self.avatar = avatar
                        }
                    }
                } else {
                    print("Failed to get user data")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

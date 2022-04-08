//
//  Profile.swift
//  Tricks
//
//  Created by armin on 12/13/20.
//

import SwiftUI
import KeychainAccess

class MyProfileViewModel: ObservableObject {
    
    @Published var isUserLoggedIn: Bool
    @Published var userToken: String
    @Published var fcmToken: String
    
    @Published var loading: Bool = false
    @Published var errorMessage: String = ""
    
    @AppStorage("userID") private var storageUserID = ""
    @AppStorage("fullname") private var storageFullname = ""
    @AppStorage("username") private var storageUsername = ""
    @AppStorage("avatarAddress") private var storageAvatarAddress = ""
    
    private var service = AuthService()
    
    init() {
        let keychain = Keychain(service: AppService.apiKey)
        let token = keychain["token"]
        
        // Check there is saved token
        if let token = token {
            isUserLoggedIn = token.count > 0
            userToken = "Bearer \(token)"
        } else {
            isUserLoggedIn = false
            userToken = ""
        }
        
        // Set Firebase cloud messaging token
        if let token = keychain["fcmToken"] {
            fcmToken = token
        } else {
            fcmToken = ""
        }
        
        Task.init {
            await getMe()
        }
    }
    
    func setToken(_ token: String) {
        let keychain = Keychain(service: AppService.apiKey)
        keychain["token"] = token
        DispatchQueue.main.async {
            withAnimation {
                self.isUserLoggedIn = token.count > 0
                self.userToken = "Bearer \(token)"
            }
        }
        
        Task.init {
            await getMe()
        }
    }
    
    func setFCMToken(_ token: String) {
        let keychain = Keychain(service: AppService.apiKey)
        keychain["fcmToken"] = token
    }
    
    func getMe() async {
        if userToken == "" { return }
        
        Task(priority: .background) {
            let result = try await service.getUser(userID: "me" ,token: userToken)
            
            switch result {
            case .success(let result):
                if result.status {
                    DispatchQueue.main.async {
                        self.storageUserID = String(result.result.id)
                        self.storageUsername = result.result.username
                        self.storageFullname = result.result.fullname
                        
                        if let avatar = result.result.avatarAddress {
                            self.storageAvatarAddress = avatar
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
    
    func logout() async {
        loading = true
        errorMessage = ""
        
        Task(priority: .background) {
            let result = try await service.logout(token: userToken ,fcmToken: nil)
            
            switch result {
            case .success(let result):
                if result.status {
                    let keychain = Keychain(service: AppService.apiKey)
                    keychain["token"] = nil
                    DispatchQueue.main.async {
                        withAnimation {
                            self.isUserLoggedIn = false
                            self.userToken = ""
                        }
                        self.storageUsername.removeAll()
                        self.storageAvatarAddress.removeAll()
                    }
                } else {
                    setErrorMessage("Failed to logout, try again")
                }
                
            case .failure(let error):
                switch error {
                case .decode:
                    setErrorMessage("Failed to execute, try later")
                case .invalidURL:
                    setErrorMessage("Invalid URL")
                case .noResponse:
                    setErrorMessage("Network error, Try again")
                case .unauthorized(_):
                    setErrorMessage("Unauthorized access")
                case .unexpectedStatusCode(let status):
                    setErrorMessage("Unexpected Status Code \(status) occured")
                case .unknown(_):
                    setErrorMessage("Network error, Try again")
                }
            }
            
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
}

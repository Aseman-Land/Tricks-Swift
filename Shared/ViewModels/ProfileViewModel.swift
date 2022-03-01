//
//  Profile.swift
//  Tricks
//
//  Created by armin on 12/13/20.
//

import SwiftUI
import KeychainAccess

class ProfileViewModel: ObservableObject {
    
    @Published var isUserLoggedIn: Bool
    @Published var userToken: String
    @Published var fcmToken: String
    
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
    }
    
    func setFCMToken(_ token: String) {
        let keychain = Keychain(service: AppService.apiKey)
        keychain["fcmToken"] = token
    }
    
    func logout() {
//        UserService.shared.logout { (result) in
//            switch result {
//            case .success:
//                let keychain = Keychain(service: AppService.apiKey)
//                keychain["token"] = nil
//                print("Logged out ✅")
//            case .failure(.badNetworkingRequest):
//                print("Network error (Logout)")
//            case .failure(.errorParse):
//                print("Error parsing data (Logout)")
//            default:
//                break
//            }
//        }
    }
}

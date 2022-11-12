//
//  Profile.swift
//  Tricks
//
//  Created by armin on 12/13/20.
//

import SwiftUI
import SimpleKeychain

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
    @AppStorage("about") private var storageAbout = ""
    
    private var authService = AuthService()
    private var usersService = UsersService()
    
    init() {
        let token = A0SimpleKeychain().string(forKey: "token")
        
        // Check there is saved token
        if let token = token {
            isUserLoggedIn = token.count > 0
            userToken = "Bearer \(token)"
        } else {
            isUserLoggedIn = false
            userToken = ""
        }
        
        // Set Firebase cloud messaging token
        if let token = A0SimpleKeychain().string(forKey: "fcmToken") {
            fcmToken = token
        } else {
            fcmToken = ""
        }
        
        Task.init {
            await getMe()
        }
    }
    
    func setToken(_ token: String) {
        A0SimpleKeychain().setString(token, forKey: "token")
        DispatchQueue.main.async {
            withAnimation {
                self.isUserLoggedIn = token.count > 0
                self.userToken = "Bearer \(token)"
                
                Task.init {
                    await self.getMe()
                }
            }
        }
    }
    
    func setFCMToken(_ token: String) {
        A0SimpleKeychain().setString(token, forKey: "fcmToken")
    }
    
    func getMe() async {
        if userToken == "" { return }
        
        do {
            let result = try await usersService.getUser(userID: "me" ,token: userToken)
            if result.status {
                DispatchQueue.main.async {
                    self.storageUserID = String(result.result.id)
                    self.storageUsername = result.result.username
                    self.storageFullname = result.result.fullname
                    self.storageAbout = result.result.about ?? ""
                    
                    if let avatar = result.result.avatarAddress {
                        self.storageAvatarAddress = avatar.absoluteString
                    }
                }
            } else {
                #if DEBUG
                print("Failed to get user data")
                #endif
            }
        } catch {
            print(error)
        }
    }
    
    func logout() async {
        DispatchQueue.main.async {
            self.loading = true
            self.errorMessage = ""
        }
        
        do {
            let result = try await authService.logout(token: userToken ,fcmToken: nil)
            if result.status {
                A0SimpleKeychain().clearAll()
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
        } catch {
            switch error as? RequestError {
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
            default:
                setErrorMessage("Network error, Try again")
            }
        }
        
        DispatchQueue.main.async {
            self.loading = false
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
}

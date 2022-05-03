//
//  AccountSettingsViewModel.swift
//  Tricks
//
//  Created by Armin on 5/3/22.
//

import SwiftUI

class AccountSettingsViewModel: ObservableObject {
    
    @AppStorage("fullname") private var storageFullname = ""
    @AppStorage("username") private var storageUsername = ""
    @AppStorage("avatarAddress") private var storageAvatarAddress = ""
    @AppStorage("about") private var storageAbout = ""
    
    @Published var fullname: String = ""
    @Published var username: String = ""
    
    @Published var currentPass: String = ""
    @Published var newPass: String = ""
    @Published var repeatNewPass: String = ""
    
    @Published var bio: String = ""
    
    @Published var profile: MyProfileViewModel? = nil
    
    @Published var loading: Bool = false
    @Published var showErrorMessage: Bool = false
    @Published var errorMessage: String = ""
    
    private var service = UsersService()
    
    func fillFields() {
        fullname = storageFullname
        username = storageUsername
        bio = storageAbout
    }
    
    func updateProfile() async {
        loading = true
        errorMessage = ""
        
        guard let profile = profile else {
            self.setErrorMessage("Failed to authorize")
            return
        }
        
        if currentPass != "" || newPass != "" || repeatNewPass != "" {
            if currentPass == "" || newPass == "" || repeatNewPass == ""{
                self.setErrorMessage("Fill all the blank fields")
                return
            } else if newPass != repeatNewPass {
                self.setErrorMessage("There is a mismatch in your new password, check it again!")
                return
            }
        }
        
        Task(priority: .background) {
            let result = try await service.editMe(
                username: username,
                fullname: fullname,
                password: newPass,
                current_password: currentPass,
                token: profile.userToken
            )
            
            switch result {
            case .success(let userResult):
                if userResult.status {
                    DispatchQueue.main.async {
                        self.storageUsername = userResult.result.username
                        self.storageFullname = userResult.result.fullname
                        self.storageAbout = userResult.result.about ?? ""
                        
                        if let avatar = userResult.result.avatarAddress {
                            self.storageAvatarAddress = avatar
                        }
                    }
                } else {
                    setErrorMessage("Failed to update profile, try again")
                }
                DispatchQueue.main.async {
                    self.loading = false
                }
            case .failure(let error):
                switch error {
                case .decode:
                    setErrorMessage("Failed to execute, try later")
                case .invalidURL:
                    setErrorMessage("Invalid URL")
                case .noResponse:
                    setErrorMessage("Network error, Try again")
                case .unauthorized(let data):
                    setErrorMessage(try await decodeErrorMessage(data))
                case .unexpectedStatusCode(let status):
                    setErrorMessage("Unexpected Status Code \(status) occured")
                case .unknown(_):
                    setErrorMessage("Network error, Try again")
                }
            }
        }
    }
    
    func decodeErrorMessage(_ data: Data) async throws -> String {
        do {
            let message = try JSONDecoder().decode(ResponseFail.self, from: data).message
            return message ?? "Try again"
        } catch {
            return "Failed to execute, Try again"
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.loading = false
            self.errorMessage = message
            self.showErrorMessage = true
        }
    }
}

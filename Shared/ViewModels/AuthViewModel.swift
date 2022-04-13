//
//  LoginViewModel.swift
//  Tricks
//
//  Created by Armin on 2/19/22.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var repeatPassword: String = ""
    @Published var email: String = ""
    @Published var fullname: String = ""
    
    @Published var loading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var userCreated: Bool = false
    
    @Published var profile: MyProfileViewModel? = nil
    
    private var service = AuthService()
    
    func login() async {
        DispatchQueue.main.async {
            self.loading = true
            self.errorMessage = ""
        }
        
        Task(priority: .background) {
            let result = try await service.login(username: username, password: password, fcmToken: "")
            
            switch result {
            case .success(let loginCall):
                if let token = loginCall.result.token {
                    DispatchQueue.main.async {
                        self.profile?.setToken(token)
                    }
                } else {
                    setErrorMessage("No token found, Try again")
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
                    setErrorMessage(try await loginErrorMessage(data))
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
    
    func signup() async {
        DispatchQueue.main.async {
            self.loading = true
            self.errorMessage = ""
        }
        
        Task(priority: .background) {
            let result = try await service.register(username: username, password: password, email: email, fullname: fullname)
            
            switch result {
            case .success(let responseSuccess):
                if responseSuccess.status {
                    DispatchQueue.main.async {
                        self.userCreated = true
                    }
                    await login()
                } else {
                    DispatchQueue.main.async {
                        self.userCreated = false
                    }
                    setErrorMessage("Failed to register, Try again")
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.userCreated = false
                }
                switch error {
                case .decode:
                    setErrorMessage("Failed to execute, try later")
                case .invalidURL:
                    setErrorMessage("Invalid URL")
                case .noResponse:
                    setErrorMessage("Network error, Try again")
                case .unauthorized(let data):
                    setErrorMessage(try await loginErrorMessage(data))
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
    
    func loginErrorMessage(_ data: Data) async throws -> String {
        do {
            let message = try JSONDecoder().decode(LoginResult.self, from: data).message
            return message
        } catch {
            return "Failed to login, Try again"
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
}

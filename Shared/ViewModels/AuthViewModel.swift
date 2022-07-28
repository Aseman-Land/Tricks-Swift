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
    
    @Published var invitationCode: String = ""
    
    @Published var loading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var profile: MyProfileViewModel? = nil
    
    private var service = AuthService()
    
    func login() async {
        DispatchQueue.main.async {
            self.loading = true
            self.errorMessage = ""
        }
        
        do {
            let result = try await service.login(username: username, password: password, fcmToken: "")
            if let token = result.result.token {
                DispatchQueue.main.async {
                    self.profile?.setToken(token)
                }
            } else {
                setErrorMessage("No token found, Try again")
            }
        } catch {
            switch error as? RequestError {
            case .decode:
                setErrorMessage("Failed to execute, try later")
            case .invalidURL:
                setErrorMessage("Invalid URL")
            case .noResponse:
                setErrorMessage("Network error, Try again")
            case .unauthorized(let data):
                setErrorMessage(await loginErrorMessage(data))
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
    
    func signup() async {
        DispatchQueue.main.async {
            self.loading = true
            self.errorMessage = ""
        }
        
        do {
            let result = try await service.register(
                username: username,
                password: password,
                email: email,
                fullname: fullname,
                invitationCode: invitationCode
            )
            
            if result.status {
                await login()
            } else {
                setErrorMessage("Failed to register, Try again")
            }
        } catch {
            switch error as? RequestError {
            case .decode:
                setErrorMessage("Failed to execute, try later")
            case .invalidURL:
                setErrorMessage("Invalid URL")
            case .noResponse:
                setErrorMessage("Network error, Try again")
            case .unauthorized(let data):
                setErrorMessage(await loginErrorMessage(data))
            case .unexpectedStatusCode(let status):
                setErrorMessage("Unexpected Status Code \(status) occured")
            default:
                setErrorMessage("Network error, Try again")
            }
        }
    }
    
    func loginErrorMessage(_ data: Data) async -> String {
        do {
            let message = try JSONDecoder().decode(ResponseFail.self, from: data).message ?? "Failed to Create account, Try again"
            return message
        } catch {
            return "Failed to Create account, Try again"
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.loading = false
            self.errorMessage = message
        }
    }
}

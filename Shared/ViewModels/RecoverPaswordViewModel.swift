//
//  RecoverPaswordViewModel.swift
//  Tricks
//
//  Created by Armin on 4/22/22.
//

import Foundation

enum RecoveryContentStatus {
    case enterEmail
    case enterCode
    case success
}

class RecoverPaswordViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var code: String = ""
    @Published var newPassword: String = ""
    
    @Published var loading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var status: RecoveryContentStatus = .enterEmail
    
    private var service = AuthService()
    
    func sendCode() async {
        DispatchQueue.main.async {
            self.errorMessage = ""
            self.loading = true
        }
        
        Task(priority: .background) {
            let result = try await service.forgotPassword(email: email)
            
            switch result {
            case .success(let result):
                if result.status {
                    DispatchQueue.main.async {
                        self.status = .enterCode
                    }
                } else {
                    setErrorMessage("Failed to send code to email, try again")
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
            
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    func recoverPassword(action: @escaping () -> Void) async {
        DispatchQueue.main.async {
            self.errorMessage = ""
            self.loading = true
        }
        
        Task(priority: .background) {
            let result = try await service.recoverPassword(email: email, code: code, newPassword: newPassword)
            
            switch result {
            case .success(let result):
                if result.status {
                    DispatchQueue.main.async {
                        self.status = .success
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            action()
                        }
                    }
                } else {
                    setErrorMessage("Failed to reset password, Try again")
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
            
            DispatchQueue.main.async {
                self.loading = false
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
            self.errorMessage = message
        }
    }
}

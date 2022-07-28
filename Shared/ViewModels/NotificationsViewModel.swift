//
//  NotificationsViewModel.swift
//  Tricks
//
//  Created by Armin on 4/19/22.
//

import Foundation

class NotificationsViewModel: ObservableObject {
    
    @Published var notifs: [Notif] = [Notif]()
    
    @Published var profile: MyProfileViewModel? = nil
    
    @Published var listStatus: ListStatus = .loading
    
    private var service = NotificationService()
    
    func getNotifications() async {
        if notifs.isEmpty {
            DispatchQueue.main.async {
                self.listStatus = .loading
            }
        }
        
        guard let profile = profile else {
            DispatchQueue.main.async {
                self.listStatus = .errorLoading("Failed to authorize")
            }
            return
        }
        
        do {
            let result = try await service.getNotifications(token: profile.userToken)
            
            if result.status {
                DispatchQueue.main.async {
                    self.notifs = result.result
                    self.listStatus = self.notifs.isEmpty ? .emptyList : .fullList
                }
            } else {
                setErrorMessage("Failed to sent the quote, try again")
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
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.listStatus = .errorLoading(message)
        }
    }
}

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
        
        Task(priority: .background) {
            let result = try await service.getNotifications(token: profile.userToken)
            
            switch result {
            case .success(let notifResult):
                if notifResult.status {
                    DispatchQueue.main.async {
                        self.notifs = notifResult.result
                        self.listStatus = self.notifs.isEmpty ? .emptyList : .fullList
                    }
                } else {
                    setErrorMessage("Failed to sent the quote, try again")
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
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.listStatus = .errorLoading(message)
        }
    }
}

enum ListStatus {
    case loading
    case fullList
    case emptyList
    case errorLoading(String)
}

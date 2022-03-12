//
//  AddQuoteViewModel.swift
//  Tricks
//
//  Created by Armin on 3/4/22.
//

import Foundation

class AddQuoteViewModel: ObservableObject {
    
    @Published var showQuoteView: Bool = false
    
    @Published var profile: MyProfileViewModel? = nil
    
    @Published var quote: String = ""
    
    @Published var loading: Bool = false
    @Published var showErrorMessage: Bool = false
    @Published var errorMessage: String = ""
    
    private var service = TricksService()
    
    func send(trickID: Int) async {
        loading = true
        errorMessage = ""
        
        guard let profile = profile else {
            self.loading = false
            self.errorMessage = "Failed to authorize"
            return
        }
        
        Task(priority: .background) {
            let result = try await service.retrickPost(trickID: trickID, quote: quote, token: profile.userToken)
            
            switch result {
            case .success(let trickResult):
                if trickResult.status {
                    DispatchQueue.main.async {
                        self.showQuoteView = false
                        NotificationCenter.default.post(name: NSNotification.UpdateList, object: nil)
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
            
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.showErrorMessage = true
        }
    }
}

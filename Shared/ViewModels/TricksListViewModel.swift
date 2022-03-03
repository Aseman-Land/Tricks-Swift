//
//  TricksListViewModel.swift
//  Tricks
//
//  Created by Armin on 3/2/22.
//

import Foundation

class TricksListViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var profile: ProfileViewModel? = nil
    
    @Published var tricks: [Trick] = [Trick]()
    
    private var service = TricksService()
    
    func loadTricks() async {
        loading = true
        errorMessage = ""
        
        guard let profile = profile else {
            self.loading = false
            self.errorMessage = "Failed to authorize"
            return
        }

        Task(priority: .background) {
            let result = try await service.myTimelineTricks(token: profile.userToken)
            
            switch result {
            case .success(let tricksResult):
                DispatchQueue.main.async {
                    self.tricks = tricksResult.result
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

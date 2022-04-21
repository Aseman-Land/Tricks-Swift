//
//  TricksListViewModel.swift
//  Tricks
//
//  Created by Armin on 3/2/22.
//

import Foundation

class TricksListViewModel: ObservableObject {
    
    @Published var type: TrickListType
    
    @Published var profile: MyProfileViewModel? = nil
    
    @Published var tricks: [Trick] = [Trick]()
    @Published var listStatus: ListStatus = .loading
    
    private var service = TricksService()
    
    init(_ type: TrickListType) {
        self.type = type
    }
    
    func loadTricks() async {
        if tricks.isEmpty {
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
            var result: Result<Tricks, RequestError>? = nil
            
            switch type {
            case .timeline:
                result = try await service.myTimelineTricks(token: profile.userToken)
            case .me:
                result = try await service.profileTricks(userID: "me", token: profile.userToken)
            case .user(let userID):
                result = try await service.profileTricks(userID: userID, token: profile.userToken)
            }
            
            switch result {
            case .success(let tricksResult):
                DispatchQueue.main.async {
                    self.tricks = tricksResult.result
                    self.listStatus = self.tricks.isEmpty ? .emptyList : .fullList
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
            case .none:
                setErrorMessage("Failed to load tricks, Try again")
            }
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.listStatus = .errorLoading(message)
        }
    }
}

enum TrickListType: Equatable {
    case timeline
    case me
    case user(userID: String)
}

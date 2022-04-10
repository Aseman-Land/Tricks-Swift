//
//  TagsViewModel.swift
//  Tricks
//
//  Created by Armin on 4/10/22.
//

import Foundation

class TagsViewModel: ObservableObject {
    
    @Published var type: TagListType
    
    @Published var profile: MyProfileViewModel? = nil
    
    @Published var tags: [Tag] = [Tag]()
    @Published var loading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var errorMessage: String = ""
    
    private var service = TagsService()
    
    init(_ type: TagListType) {
        self.type = type
    }
    
    func loadTricks() async {
        loading = true
        errorMessage = ""
        
        guard let profile = profile else {
            self.loading = false
            self.isRefreshing = false
            self.errorMessage = "Failed to authorize"
            return
        }

        Task(priority: .background) {
            var result: Result<Tags, RequestError>? = nil
            
            switch type {
            case .all:
                result = try await service.globalTags(token: profile.userToken)
            case .me:
                result = try await service.myTags(token: profile.userToken)
            }
            
            switch result {
            case .success(let tagsResult):
                DispatchQueue.main.async {
                    self.tags = tagsResult.result
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
            
            DispatchQueue.main.async {
                self.loading = false
                self.isRefreshing = false
            }
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
}

enum TagListType: Equatable {
    case all
    case me
}

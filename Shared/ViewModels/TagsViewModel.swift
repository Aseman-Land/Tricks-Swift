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

        do {
            switch type {
            case .all:
                let tagsResult = try await service.globalTags(token: profile.userToken)
                DispatchQueue.main.async {
                    self.tags = tagsResult.result
                }
            case .me:
                let tagsResult = try await service.myTags(token: profile.userToken)
                DispatchQueue.main.async {
                    self.tags = tagsResult.result
                }
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
        DispatchQueue.main.async {
            self.loading = false
            self.isRefreshing = false
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

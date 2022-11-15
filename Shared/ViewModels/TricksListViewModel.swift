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
    
    @Published var isRefreshing: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var noMore: Bool = false
    
    var currentOffset: Int = 0
    
    private var service = TricksService()
    
    init(_ type: TrickListType) {
        self.type = type
    }
    
    func loadMore() async {
        #if DEBUG
        print("🔁 Loading more content, offset :\(currentOffset + 20)")
        #endif
        await loadTricks()
    }
    
    func loadTricks(limit: Int = 20) async {
        if tricks.isEmpty {
            DispatchQueue.main.async {
                self.listStatus = .loading
            }
        }
        
        guard let profile = profile else {
            DispatchQueue.main.async {
                self.isRefreshing = false
                self.listStatus = .errorLoading("Failed to authorize")
            }
            return
        }

        do {
            switch type {
            case .timeline:
                setResult(
                    tricksResult: try await service.myTimelineTricks(
                        token: profile.userToken,
                        limit: limit,
                        offset: currentOffset
                    ).result,
                    limit: limit
                )
            case .global:
                setResult(
                    tricksResult: try await service.globalTricks(
                        token: profile.userToken,
                        limit: limit,
                        offset: currentOffset
                    ).result,
                    limit: limit
                )
            case .me:
                setResult(
                    tricksResult: try await service.profileTricks(
                        userID: "me",
                        token: profile.userToken,
                        limit: limit,
                        offset: currentOffset
                    ).result,
                    limit: limit
                )
            case .user(let userID):
                setResult(
                    tricksResult: try await service.profileTricks(
                        userID: userID,
                        token: profile.userToken,
                        limit: limit,
                        offset: currentOffset
                    ).result,
                    limit: limit
                )
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
    
    private func setResult(tricksResult: [Trick], limit: Int) {
        DispatchQueue.main.async {
            self.isRefreshing = false
            if self.currentOffset == 0 {
                self.tricks = tricksResult
                self.currentOffset = limit
                self.noMore = false
            } else {
                if !tricksResult.isEmpty {
                    self.tricks.append(contentsOf: tricksResult)
                    self.currentOffset += limit
                } else {
                    self.noMore = true
                }
                self.isLoadingMore = false
            }
            self.listStatus = self.tricks.isEmpty ? .emptyList : .fullList
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.isRefreshing = false
            self.listStatus = .errorLoading(message)
        }
    }
}

enum TrickListType: Equatable {
    case global
    case timeline
    case me
    case user(userID: String)
}

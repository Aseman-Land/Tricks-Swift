//
//  TrickViewModel.swift
//  Tricks
//
//  Created by Armin on 3/19/22.
//

import SwiftUI

class TrickViewModel: ObservableObject {
    
    @Published var trick: Trick
    @Published var liked: Bool = false
    @Published var willDelete: Bool = false
    
    @Published var profile: MyProfileViewModel? = nil
    @AppStorage("userID") private var storageUserID = ""
    
    private var service = TricksService()
    
    init(trick: Trick) {
        self.trick = trick
        self.liked = trick.rate_state == 1
    }
    
    var isMine: Bool {
        return trick.owner.id == Int(storageUserID)
    }
    
    var trickQuoteBody: String {
        let body = (trick.quote != nil ? trick.quote?.quote ?? "" : trick.body) ?? ""
        return body
    }
    
    var trickBody: String {
        return trick.body ?? ""
    }
    
    func copyCode() {
        if let code = trick.code {
            #if os(iOS)
            let pasteboard = UIPasteboard.general
            pasteboard.string = code
            HapticGenerator.shared.success()
            #elseif os(macOS)
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(code, forType: .string)
            #endif
        }
    }
    
    func shareBody() -> [Any] {
        #if os(iOS)
        return [
            trick.body,
            trick.code,
            "By \(trick.owner.fullname)",
            URL(string: trick.share_link ?? trick.previewAddress)!
        ]
        #else
        return [trick.share_link ?? trick.previewAddress]
        #endif
    }
    
    func addLike() async {
        liked = !liked
        trick.rates += liked ? 1 : -1
        
        guard let profile = profile else {
            liked = !liked
            trick.rates -= 1
            print("Warning: No profile found!")
            return
        }

        Task(priority: .background) {
            let result = try await service.addRate(tagID: trick.id, rate: liked ? 1 : 0, token: profile.userToken)
            
            switch result {
            case .success(let trickResult):
                if let trick = trickResult.result.first {
                    DispatchQueue.main.async {
                        self.trick = trick
                        self.liked = trick.rate_state == 1
                    }
                } else {
                    liked = !liked
                    trick.rates -= 1
                    print("Failed to sent the rate, try again")
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.liked = !(self.liked)
                    self.trick.rates -= 1
                }
                switch error {
                case .decode:
                    print("Failed to execute, try later")
                case .invalidURL:
                    print("Invalid URL")
                case .noResponse:
                    print("Network error, Try again")
                case .unauthorized(_):
                    print("Unauthorized access")
                case .unexpectedStatusCode(let status):
                    print("Unexpected Status Code \(status) occured")
                case .unknown(_):
                    print("Network error, Try again")
                }
            }
        }
    }
    
    func deleteTrick() async {
        guard let profile = profile else {
            print("Failed to authorize")
            return
        }
        
        Task(priority: .background) {
            let result = try await service.deleteTrickPost(trickID: trick.id, token: profile.userToken)
            
            switch result {
            case .success(let response):
                if response.result {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.UpdateList, object: nil)
                    }
                } else {
                    print("Failed to delete the trick, try again")
                }
            case .failure(let error):
                switch error {
                case .decode:
                    print("Failed to execute, try later")
                case .invalidURL:
                    print("Invalid URL")
                case .noResponse:
                    print("Network error, Try again")
                case .unauthorized(_):
                    print("Unauthorized access")
                case .unexpectedStatusCode(let status):
                    print("Unexpected Status Code \(status) occured")
                case .unknown(_):
                    print("Network error, Try again")
                }
            }
        }
    }
}

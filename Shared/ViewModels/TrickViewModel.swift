//
//  TrickViewModel.swift
//  Tricks
//
//  Created by Armin on 3/19/22.
//

import Foundation

class TrickViewModel: ObservableObject {
    
    @Published var trick: Trick
    @Published var liked: Bool = false
    
    @Published var profile: MyProfileViewModel? = nil
    
    private var service = TricksService()
    
    init(trick: Trick) {
        self.trick = trick
        self.liked = trick.rate_state == 1
    }
    
    var trickOwnerAvatar: URL? {
        return URL(string: "https://\(AppService.apiKey)/api/v1/\(trick.owner.avatar ?? "")")
    }
    
    var trickDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: trick.datetime) ?? Date()
    }
    
    func addLike() async {
        liked = !liked
        
        guard let profile = profile else {
            liked = !liked
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
                    print("Failed to sent the rate, try again")
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.liked = !(self.liked)
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
}

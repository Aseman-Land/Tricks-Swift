//
//  User.swift
//  Tricks
//
//  Created by Armin on 2/19/22.
//

import Foundation

// MARK: - User
public struct User: Codable {
    let result: UserResult
    let status: Bool
}

public struct Users: Codable {
    let result: [UserResult]
    let status: Bool
}

public struct UserResult: Codable {
    let id: Int
    let username: String
    let fullname: String
    let about: String?
    let joinDate: String?
    let avatar, cover: String?
    let followersCount, followingsCount, tricksCount: Int
    let details: UserDetails?
    let isFollower, isFollowed: Bool?
    
    var avatarAddress: URL? {
        if let avatar {
            return URL(string: "https://\(AppService.BASE_ADDRESS)/api/v1/\(avatar)")
        }
        return nil
    }
    
    var coverAddress: URL? {
        if let cover {
            return URL(string: "https://\(AppService.BASE_ADDRESS)/api/v1/\(cover)")
        }
        return nil
    }
    
    var joinedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self.joinDate ?? "") ?? Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, username, fullname, about
        case joinDate = "join_date"
        case avatar, cover, details
        case followersCount = "followers_count"
        case followingsCount = "followings_count"
        case tricksCount = "tricks_count"
        case isFollower = "is_follower"
        case isFollowed = "is_followed"
    }
}

public extension UserResult {
    static func placeHolder() -> UserResult {
        UserResult(
            id: -1,
            username: "Tricks",
            fullname: "Tricks Social Network",
            about: "Official Account",
            joinDate: "1111-01-01T00:00:00",
            avatar: "storage/static/avatar.png",
            cover: nil,
            followersCount: 40,
            followingsCount: 0,
            tricksCount: 3,
            details: UserDetails(role: 1),
            isFollower: false,
            isFollowed: true
        )
    }
}

// MARK: - UserDetails
public struct UserDetails: Codable {
    let role: Int?
}

// MARK: - Login
public struct LoginCall: Codable {
    let result: LoginResult
    let status: Bool
}

public struct LoginResult: Codable {
    let message: String
    let token: String?
}

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
            return URL(string: "https://\(AppService.apiKey)/api/v1/\(avatar)")
        }
        return nil
    }
    
    var coverAddress: URL? {
        if let cover {
            return URL(string: "https://\(AppService.apiKey)/api/v1/\(cover)")
        }
        return nil
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
    
    static let mockExample = UserResult(
        id: 1,
        username: "realbardia",
        fullname: "Bardia Daneshvar",
        about: "I'm a C++ and Rust Developer :)",
        joinDate: "2021-03-03T20:38:04",
        avatar: "storage/upload/1/a92e7655-1d03-46c4-af07-408e68ba464c.jpeg",
        cover: "storage/upload/1/62a45d0c-cbcc-403a-bed2-cda8115cac8f.jpg",
        followersCount: 4,
        followingsCount: 3,
        tricksCount: 4,
        details: UserDetails(role: 0),
        isFollower: nil,
        isFollowed: nil
    )
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

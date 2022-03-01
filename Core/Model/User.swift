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
    let avatar: String?
    let followersCount, followingsCount, tricksCount: Int
    let details: UserDetails?
    let isFollower, isFollowed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, username, fullname, about
        case joinDate = "join_date"
        case avatar, details
        case followersCount = "followers_count"
        case followingsCount = "followings_count"
        case tricksCount = "tricks_count"
        case isFollower = "is_follower"
        case isFollowed = "is_followed"
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

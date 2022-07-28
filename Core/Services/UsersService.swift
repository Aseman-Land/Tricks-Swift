//
//  UsersService.swift
//  Tricks
//
//  Created by Armin on 5/2/22.
//

import Foundation

protocol UsersServiceable {
    func getUser(
        userID: String,
        token: String
    ) async throws -> User
    
    func searchUsers(
        keyword: String,
        token: String,
        offset: Int?,
        limit: Int?
    ) async throws -> Users
    
    func getMe(
        token: String
    ) async throws -> User
    
    func editMe(
        username: String?,
        fullname: String?,
        password: String?,
        current_password: String?,
        token: String
    ) async throws -> User
    
    func deleteMe(
        token: String
    ) async throws -> GlobalResponse
    
    func getMyFollowers(
        token: String
    ) async throws -> Users

    func getUserFollowers(
        userID: String,
        token: String
    ) async throws -> Users

    // MARK: - Followings
    func getMyFollowings(
        token: String
    ) async throws -> Users

    func getUserFollowings(
        userID: String,
        token: String
    ) async throws -> Users

    func followSomeone(
        userID: String,
        token: String
    ) async throws -> User

    func unfollowSomeone(
        userID: String,
        token: String
    ) async throws -> User

    // MARK: - Avatar
    func updateAvatar(
        avatar: Data,
        token: String
    ) async throws -> User

    // MARK: - Blocks
    func blockSomeone(
        userID: String,
        token: String
    ) async throws -> GlobalResponse

    func unblockSomeone(
        userID: String,
        token: String
    ) async throws -> GlobalResponse

    // MARK: - Mutes
    func muteSomeone(
        userID: String,
        token: String
    ) async throws -> GlobalResponse

    func unmuteSomeone(
        userID: String,
        token: String
    ) async throws -> GlobalResponse

    // MARK: - Reports
    func reportSomeone(
        userID: String,
        message: String,
        reportType: Int,
        token: String
    ) async throws -> GlobalResponse
}

struct UsersService: HTTPClient, UsersServiceable {
    func getUser(
        userID: String,
        token: String
    ) async throws -> User {
        return try await sendRequest(
            endpoint: UsersEndpoint.getUser(
                userID: userID,
                token: token
            ),
            responseModel: User.self
        )
    }
    
    func searchUsers(
        keyword: String,
        token: String,
        offset: Int?,
        limit: Int?
    ) async throws -> Users {
        return try await sendRequest(
            endpoint: UsersEndpoint.searchUsers(
                keyword: keyword,
                token: token,
                offset: offset,
                limit: limit
            ),
            responseModel: Users.self
        )
    }
    
    func getMe(
        token: String
    ) async throws -> User {
        return try await sendRequest(
            endpoint: UsersEndpoint.getMe(
                token: token
            ),
            responseModel: User.self
        )
    }
    
    func editMe(
        username: String?,
        fullname: String?,
        password: String?,
        current_password: String?,
        token: String
    ) async throws -> User {
        return try await sendRequest(
            endpoint:
                UsersEndpoint.editMe(
                    username: username,
                    fullname: fullname,
                    password: password,
                    current_password: current_password,
                    token: token
                ),
            responseModel: User.self
        )
    }
    
    func deleteMe(
        token: String
    ) async throws -> GlobalResponse {
        return try await sendRequest(
            endpoint: UsersEndpoint.deleteMe(token: token),
            responseModel: GlobalResponse.self
        )
    }
    
    func getMyFollowers(token: String) async throws -> Users {
        return try await sendRequest(
            endpoint: UsersEndpoint.getMyFollowers(token: token),
            responseModel: Users.self
        )
    }
    
    func getUserFollowers(userID: String, token: String) async throws -> Users {
        return try await sendRequest(
            endpoint: UsersEndpoint.getUserFollowers(userID: userID, token: token),
            responseModel: Users.self
        )
    }
    
    func getMyFollowings(token: String) async throws -> Users {
        return try await sendRequest(
            endpoint: UsersEndpoint.getMyFollowings(token: token),
            responseModel: Users.self
        )
    }
    
    func getUserFollowings(userID: String, token: String) async throws -> Users {
        return try await sendRequest(
            endpoint: UsersEndpoint.getUserFollowings(userID: userID, token: token),
            responseModel: Users.self
        )
    }
    
    func followSomeone(userID: String, token: String) async throws -> User {
        return try await sendRequest(
            endpoint: UsersEndpoint.followSomeone(userID: userID, token: token),
            responseModel: User.self
        )
    }
    
    func unfollowSomeone(userID: String, token: String) async throws -> User {
        return try await sendRequest(
            endpoint: UsersEndpoint.unfollowSomeone(userID: userID, token: token),
            responseModel: User.self
        )
    }
    
    func updateAvatar(avatar: Data, token: String) async throws -> User {
        return try await sendRequest(
            endpoint: UsersEndpoint.updateAvatar(avatar: avatar, token: token),
            responseModel: User.self
        )
    }
    
    func blockSomeone(userID: String, token: String) async throws -> GlobalResponse {
        return try await sendRequest(
            endpoint: UsersEndpoint.blockSomeone(userID: userID, token: token),
            responseModel: GlobalResponse.self
        )
    }
    
    func unblockSomeone(userID: String, token: String) async throws -> GlobalResponse {
        return try await sendRequest(
            endpoint: UsersEndpoint.unblockSomeone(userID: userID, token: token),
            responseModel: GlobalResponse.self
        )
    }
    
    func muteSomeone(userID: String, token: String) async throws -> GlobalResponse {
        return try await sendRequest(
            endpoint: UsersEndpoint.muteSomeone(userID: userID, token: token),
            responseModel: GlobalResponse.self
        )
    }
    
    func unmuteSomeone(userID: String, token: String) async throws -> GlobalResponse {
        return try await sendRequest(
            endpoint: UsersEndpoint.unmuteSomeone(userID: userID, token: token),
            responseModel: GlobalResponse.self
        )
    }
    
    func reportSomeone(userID: String, message: String, reportType: Int, token: String) async throws -> GlobalResponse {
        return try await sendRequest(
            endpoint: UsersEndpoint.reportSomeone(
                userID: userID,
                message: message,
                reportType: reportType,
                token: token
            ),
            responseModel: GlobalResponse.self
        )
    }
}

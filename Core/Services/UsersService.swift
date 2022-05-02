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
    ) async throws -> Result<User, RequestError>
    
    func searchUsers(
        keyword: String,
        token: String,
        offset: Int?,
        limit: Int?
    ) async throws -> Result<Users, RequestError>
    
    func getMe(
        token: String
    ) async throws -> Result<User, RequestError>
    
    func editMe(
        username: String?,
        fullname: String?,
        password: String?,
        current_password: String?,
        token: String
    ) async throws -> Result<User, RequestError>
    
    func deleteMe(
        token: String
    ) async throws -> Result<GlobalResponse, RequestError>
}

struct UsersService: HTTPClient, UsersServiceable {
    func getUser(
        userID: String,
        token: String
    ) async throws -> Result<User, RequestError> {
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
    ) async throws -> Result<Users, RequestError> {
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
    ) async throws -> Result<User, RequestError> {
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
    ) async throws -> Result<User, RequestError> {
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
    ) async throws -> Result<GlobalResponse, RequestError> {
        return try await sendRequest(
            endpoint: UsersEndpoint.deleteMe(token: token),
            responseModel: GlobalResponse.self
        )
    }
}

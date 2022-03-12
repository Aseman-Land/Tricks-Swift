//
//  AuthService.swift
//  Tricks
//
//  Created by Armin on 2/24/22.
//

import Foundation

protocol AuthServiceable {
    func login(
        username: String,
        password: String,
        fcmToken: String?
    ) async throws -> Result<LoginCall, RequestError>
    
    func register(
        username: String,
        password: String,
        email: String,
        fullname: String
    ) async throws -> Result<ResponseSuccess, RequestError>
    
    func logout(token: String, fcmToken: String?) async throws -> Result<GlobalResponse, RequestError>
    
    func getUser(
        userID: String,
        token: String
    ) async throws -> Result<User, RequestError>
    
    func editMe(
        username: String?,
        fullname: String?,
        password: String?,
        current_password: String?,
        token: String
    ) async throws -> Result<User, RequestError>
}

struct AuthService: HTTPClient, AuthServiceable {
    func login(
        username: String,
        password: String,
        fcmToken: String?
    ) async throws -> Result<LoginCall, RequestError> {
        return try await sendRequest(
            endpoint: AuthEndpoint.login(
                username: username,
                password: password,
                fcmToken: fcmToken
            ),
            responseModel: LoginCall.self
        )
    }
    
    func register(
        username: String,
        password: String,
        email: String,
        fullname: String
    ) async throws -> Result<ResponseSuccess, RequestError> {
        return try await sendRequest(
            endpoint: AuthEndpoint.register(username: username, password: password, email: email, fullname: fullname),
            responseModel: ResponseSuccess.self
        )
    }
    
    func logout(token: String, fcmToken: String?) async throws -> Result<GlobalResponse, RequestError> {
        return try await sendRequest(
            endpoint: AuthEndpoint.logout(token: token, fcmToken: fcmToken),
            responseModel: GlobalResponse.self
        )
    }
    
    func getUser(
        userID: String,
        token: String
    ) async throws -> Result<User, RequestError> {
        return try await sendRequest(endpoint: AuthEndpoint.getUser(userID: userID, token: token), responseModel: User.self)
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
                AuthEndpoint.editMe(
                    username: username,
                    fullname: fullname,
                    password: password,
                    current_password: current_password,
                    token: token
                ),
            responseModel: User.self
        )
    }
}

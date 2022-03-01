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
}

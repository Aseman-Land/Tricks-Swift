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
        fullname: String,
        invitationCode: String
    ) async throws -> Result<ResponseSuccess, RequestError>
    
    func logout(
        token: String,
        fcmToken: String?
    ) async throws -> Result<GlobalResponse, RequestError>
    
    func forgotPassword(
        email: String
    ) async throws -> Result<GlobalResponse, RequestError>
    
    func recoverPassword(
        email: String,
        code: String,
        newPassword: String
    ) async throws -> Result<GlobalResponse, RequestError>
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
        fullname: String,
        invitationCode: String
    ) async throws -> Result<ResponseSuccess, RequestError> {
        return try await sendRequest(
            endpoint: AuthEndpoint.register(
                username: username,
                password: password,
                email: email,
                fullname: fullname,
                invitationCode: invitationCode
            ),
            responseModel: ResponseSuccess.self
        )
    }
    
    func logout(
        token: String,
        fcmToken: String?
    ) async throws -> Result<GlobalResponse, RequestError> {
        return try await sendRequest(
            endpoint: AuthEndpoint.logout(
                token: token,
                fcmToken: fcmToken
            ),
            responseModel: GlobalResponse.self
        )
    }
    
    func forgotPassword(
        email: String
    ) async throws -> Result<GlobalResponse, RequestError> {
        return try await sendRequest(
            endpoint: AuthEndpoint.forgotPassword(email: email),
            responseModel: GlobalResponse.self
        )
    }
    
    func recoverPassword(
        email: String,
        code: String,
        newPassword: String
    ) async throws -> Result<GlobalResponse, RequestError> {
        return try await sendRequest(
            endpoint: AuthEndpoint.recoverPassword(
                email: email,
                code: code,
                newPassword: newPassword
            ),
            responseModel: GlobalResponse.self
        )
    }
}

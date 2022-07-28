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
    ) async throws -> LoginCall
    
    func register(
        username: String,
        password: String,
        email: String,
        fullname: String,
        invitationCode: String
    ) async throws -> ResponseSuccess
    
    func logout(
        token: String,
        fcmToken: String?
    ) async throws -> GlobalResponse
    
    func forgotPassword(
        email: String
    ) async throws -> GlobalResponse
    
    func recoverPassword(
        email: String,
        code: String,
        newPassword: String
    ) async throws -> GlobalResponse
}

struct AuthService: HTTPClient, AuthServiceable {
    func login(
        username: String,
        password: String,
        fcmToken: String?
    ) async throws -> LoginCall {
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
    ) async throws -> ResponseSuccess {
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
    ) async throws -> GlobalResponse {
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
    ) async throws -> GlobalResponse {
        return try await sendRequest(
            endpoint: AuthEndpoint.forgotPassword(email: email),
            responseModel: GlobalResponse.self
        )
    }
    
    func recoverPassword(
        email: String,
        code: String,
        newPassword: String
    ) async throws -> GlobalResponse {
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

//
//  AuthEndpoint.swift
//  Tricks
//
//  Created by Armin on 2/20/22.
//

import Foundation

enum AuthEndpoint {
    // MARK: - Tricks Authentication
    case login(
        username: String,
        password: String,
        fcmToken: String?
    )
    
    case register(
        username: String,
        password: String,
        email: String,
        fullname: String,
        invitationCode: String
    )
    
    case logout(
        token: String,
        fcmToken: String?
    )
    
    // MARK: - Forgot Password
    case forgotPassword(
        email: String
    )
    
    case recoverPassword(
        email: String,
        code: String,
        newPassword: String
    )
    
    // MARK: - Github
    case requestGithubLink
    
    case checkGithubRegisteration(
        sessionID: String
    )
    
    case githubRegister(
        username: String,
        fullname: String,
        githubRegisterToken: String,
        agreementVersion: Int
    )
    
    case githubConnectToAccount(
        registerToken: String
    )
}

extension AuthEndpoint: Endpoint {
    var path: String {
        switch self {
        case .login(_, _, _):
            return "/api/v1/auth/login"
        case .register(_, _, _, _, _):
            return "/api/v1/users"
        case .logout(_, _):
            return "/api/v1/auth/logout"
        case .forgotPassword(_):
            return "/api/v1/auth/forget-password"
        case .recoverPassword(_, _, _):
            return "/api/v1/auth/forget-password/recover"
        case .requestGithubLink:
            return "/api/v1/auth/github"
        case .checkGithubRegisteration(_):
            return "api/v1/auth/github/check"
        case .githubRegister(_, _, _, _):
            return "/api/v1/users"
        case .githubConnectToAccount(_):
            return "/api/v1/auth/github/check"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestGithubLink,
             .checkGithubRegisteration(_):
            return .get
        default:
            return .post
        }
        
    }
    
    var header: [String : String]? {
        switch self {
        case .logout(let token, _):
            return [
                "Authorization": token,
                "Content-Type":"\(HTTPContentType.applicationJSON); \(HTTPContentType.charsetUTF8)",
            ]
        default:
            return ["Content-Type":"\(HTTPContentType.applicationJSON); \(HTTPContentType.charsetUTF8)"]
        }
    }
    
    var urlParams: [URLQueryItem]? {
        switch self {
        case .checkGithubRegisteration(let sessionID):
            return [URLQueryItem(name: "session_id", value: sessionID)]
        default:
            return nil
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .login(let username, let password, _):
            let securedPassword = SecureKey(password: password).securedKey
            return [
                "username": username,
                "password": securedPassword,
                //"fcm_token": Profile().getFCMToken
            ]
        
        case .register(
            let username,
            let password,
            let email,
            let fullname,
            let invitationCode
        ):
            let securedPassword = SecureKey(password: password).securedKey
            return [
                "username": username,
                "password": securedPassword,
                "email": email,
                "fullname": fullname,
                "invitation_code": invitationCode
            ]
            
        case .logout(_, let fcmToken):
            if let fcmToken = fcmToken {
                return ["fcm_token": fcmToken]
            } else {
                return [:]
            }
            
        case .forgotPassword(let email):
            return ["email": email]
            
        case .recoverPassword(let email, let code, let newPassword):
            let securedPassword = SecureKey(password: newPassword).securedKey
            return [
                "email": email,
                "code": code,
                "new_password": securedPassword
            ]
        case .githubRegister(
            let username,
            let fullname,
            let githubRegisterToken,
            let agreementVersion
        ):
            return [
                "username": username,
                "fullname": fullname,
                "github_register_token": githubRegisterToken,
                "agreement_version": agreementVersion
            ]
        case .githubConnectToAccount(registerToken: let registerToken):
            return ["register_token": registerToken]
        default:
            return nil
        }
    }
}

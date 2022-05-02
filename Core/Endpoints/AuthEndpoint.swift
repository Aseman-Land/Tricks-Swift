//
//  AuthEndpoint.swift
//  Tricks
//
//  Created by Armin on 2/20/22.
//

import Foundation
import CryptoKit

enum AuthEndpoint {
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
    
    case forgotPassword(
        email: String
    )
    
    case recoverPassword(
        email: String,
        code: String,
        newPassword: String
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
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var header: [String : String]? {
        switch self {
        case .logout(let token, _):
            return [
                "Authorization": token,
                "Content-Type":"application/json; charset=utf-8",
            ]
        default:
            return ["Content-Type":"application/json; charset=utf-8"]
        }
    }
    
    var urlParams: [URLQueryItem]? {
        return nil
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
        
        case .register(let username, let password, let email, let fullname, let invitationCode):
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
        }
    }
}

public actor SecureKey {
    let securedKey: String
    
    init(password: String) {
        let pass = "\(AppService.passwordSalt)\(password)\(AppService.passwordSalt)"
        let hashed = SHA256.hash(data: Data(pass.utf8))
        self.securedKey = hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

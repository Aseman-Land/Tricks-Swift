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
        fullname: String
    )
    
    case logout(
        token: String,
        fcmToken: String?
    )
    
    case getUser(
        userID: String,
        token: String
    )
    
    case editMe(
        username: String?,
        fullname: String?,
        password: String?,
        current_password: String?,
        token: String
    )
}

extension AuthEndpoint: Endpoint {
    var path: String {
        switch self {
        case .login(_, _, _):
            return "/api/v1/auth/login"
        case .register(_, _, _, _):
            return "/api/v1/users"
        case .logout(_, _):
            return "/api/v1/auth/logout"
        case .getUser(let userID, _):
            return "/api/v1/users/\(userID)"
        case .editMe(_, _, _, _, _):
            return "/api/v1/users/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login(_, _, _),
             .register(_, _, _, _),
             .logout(_, _):
            return .post
        case .getUser(_, _):
            return .get
        case .editMe(_, _, _, _, _):
            return .patch
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .logout(let token, _),
             .getUser(_, let token),
             .editMe(_, _, _, _, let token):
            return [
                "Authorization": token,
                "Content-Type":"application/json; charset=utf-8",
            ]
        default:
            return ["Content-Type":"application/json; charset=utf-8"]
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
        
        case .register(let username, let password, let email, let fullname):
            let securedPassword = SecureKey(password: password).securedKey
            return [
                "username": username,
                "password": securedPassword,
                "email": email,
                "fullname": fullname
            ]
            
        case .logout(_, let fcmToken):
            if let fcmToken = fcmToken {
                return ["fcm_token": fcmToken]
            } else {
                return [:]
            }
            
        case .getUser(_, _):
            return nil
            
        case .editMe(let username , let fullname, let password, let current_password, _):
            var editBody = [String : String]()
            
            if let username = username {
                editBody["username"] = username
            }
            
            if let fullname = fullname {
                editBody["fullname"] = fullname
            }
            
            if let password = password {
                editBody["password"] = password
            }
            
            if let current_password = current_password {
                editBody["current_password"] = current_password
            }
            
            return editBody
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

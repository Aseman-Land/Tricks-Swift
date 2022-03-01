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
}

extension AuthEndpoint: Endpoint {
    var path: String {
        switch self {
        case .login(_, _, _):
            return "/api/v1/auth/login"
        case .register(_, _, _, _):
            return "/api/v1/users"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var header: [String : String]? {
        return ["Content-Type":"application/json; charset=utf-8"]
    }
    
    var body: [String : String]? {
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

//
//  SecureKey.swift
//  Tricks
//
//  Created by Armin on 5/3/22.
//

import Foundation
import CryptoKit

public actor SecureKey {
    let securedKey: String
    
    init(password: String) {
        let pass = "\(AppService.passwordSalt)\(password)\(AppService.passwordSalt)"
        let hashed = SHA256.hash(data: Data(pass.utf8))
        self.securedKey = hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

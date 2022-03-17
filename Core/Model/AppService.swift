//
//  AppService.swift
//  Tricks
//
//  Created by Armin on 2/19/22.
//

import Foundation

struct AppService {
    static var apiKey: String {
        if let apiKey = Bundle.main.infoDictionary?["API_DOMAIN"] as? String {
            return apiKey
        }
        return ""
    }
    
    static var passwordSalt: String {
        if let salt = Bundle.main.infoDictionary?["REGISTER_SALT"] as? String {
            return salt
        }
        return ""
    }
    
    func imageURL(url: String?) -> String {
        if let url = url {
            return "https://\(AppService.apiKey)/api/v1/\(url)"
        }
        return ""
    }
}

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
    
    static var apiAppID: String {
        if let result = Bundle.main.infoDictionary?["API_APP_ID"] as? String {
            return result
        }
        return ""
    }
    
    static var apiAppVersion: String {
        if let result = Bundle.main.infoDictionary?["API_APP_VERSION"] as? String {
            return result
        }
        return ""
    }
    
    func imageURL(url: String?) -> URL? {
        if let url = url {
            return URL(string: "https://\(AppService.apiKey)/api/v1/\(url)")
        }
        return nil
    }
}

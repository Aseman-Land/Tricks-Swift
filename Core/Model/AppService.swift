//
//  AppService.swift
//  Tricks
//
//  Created by Armin on 2/19/22.
//

import Foundation

struct AppService {
    static var BASE_ADDRESS = "tricks.aseman.io"
    static var PASSWORD_SALT = "92bcd38b-9aae-4528-a5b0-4c38489db279"
    static var APP_ID = ""
    static var APP_VERSION = "4"
}

extension AppService {
    func imageURL(url: String?) -> URL? {
        if let url = url {
            return URL(string: "https://\(AppService.BASE_ADDRESS)/api/v1/\(url)")
        }
        return nil
    }
}

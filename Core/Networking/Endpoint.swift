//
//  Endpoint.swift
//  Tricks
//
//  Created by Armin on 2/20/22.
//

import Foundation

public protocol Endpoint {
    var baseURL:    String            { get }
    var path:       String            { get }
    var method:     HTTPMethod        { get }
    var baseHeader: [String: String]  { get }
    var header:     [String: String]? { get }
    var urlParams:  [URLQueryItem]?   { get }
    var body:       [String: Any]?    { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://\(AppService.apiKey)"
    }
    
    var baseHeader: [String: String] {
        return [
            "App-Version": AppService.apiAppVersion,
            "App-Secret-ID": AppService.apiAppID,
        ]
    }
}

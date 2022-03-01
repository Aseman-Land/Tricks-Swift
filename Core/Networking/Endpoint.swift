//
//  Endpoint.swift
//  Tricks
//
//  Created by Armin on 2/20/22.
//

import Foundation

public protocol Endpoint {
    var baseURL: String            { get }
    var path:    String            { get }
    var method:  HTTPMethod        { get }
    var header:  [String: String]? { get }
    var body:    [String: String]? { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://\(AppService.apiKey)"
    }
}
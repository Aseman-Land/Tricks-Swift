//
//  ResponseCall.swift
//  Aseman
//
//  Created by armin on 1/10/21.
//

import Foundation

// MARK: - ResponseError
struct ResponseError: Codable {
    let status: Bool
    let errorCode: Int?
    let httpCode: Int?
    let message: String
}

struct ResponseSuccess: Codable {
    let status: Bool
    let result: Int?
}
struct ResponseFail: Codable {
    let status: Bool
    let error_code: Int?
    let http_code: Int?
    let message: String?
}

struct ResponseStatus: Codable {
    let status: Bool
}

struct ResponseID: Codable {
    let id: Int
}

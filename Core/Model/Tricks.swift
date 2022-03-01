//
//  Tricks.swift
//  CodeTrick
//
//  Created by armin on 3/5/21.
//

import Foundation

// MARK: - Tricks
struct Tricks: Codable {
    let result: [TricksResult]
    let status: Bool
}

// MARK: - Result
struct TricksResult: Codable {
    let id: Int
    let body: String
    let code: String
    let owner: UserResult
    let datetime: String
    let highlighter: GlobalTrickItemDetail
    let programing_language: GlobalTrickItemDetail?
    let code_frame: GlobalTrickItemDetail?
    let type: TrickTypeClass
    let views, rates, rate_state: Int
    let tags: [String?]
    let filename: String?
    let quote: Quote?
    let image_size: CodePreviewDetail?
}

// MARK: - GlobalTrickItemDetail
struct GlobalTrickItemDetail: Codable {
    let id: Int
    let name: String
}

// MARK: - Quote
struct Quote: Codable {
    let trickID: Int
    let quote: String
    let user: UserResult

    enum CodingKeys: String, CodingKey {
        case trickID = "trick_id"
        case quote, user
    }
}

// MARK: - CodePreviewDetail
struct CodePreviewDetail: Codable {
    let width: Int
    let height: Int
}

// MARK: - TypeClass
struct TrickTypeClass: Codable {
    let id: Int
    let name: String
    let typeDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case typeDescription = "description"
    }
}

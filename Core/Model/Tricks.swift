//
//  Tricks.swift
//  CodeTrick
//
//  Created by armin on 3/5/21.
//

import Foundation

// MARK: - Tricks
struct Tricks: Codable {
    let result: [Trick]
    let status: Bool
}

// MARK: - Result
struct Trick: Codable {
    let id: Int
    let body: String
    let code: String
    let owner: UserResult
    let datetime: String
    let highlighter: GlobalTrickItemDetail
    let programing_language: GlobalTrickItemDetail?
    let code_frame: GlobalTrickItemDetail?
    let type: TrickTypeClass
    var views, rates, rate_state: Int
    let tags: [String?]
    let filename: String?
    let quote: Quote?
    let image_size: CodePreviewDetail?
    
    var previewAddress: String {
        return AppService().imageURL(url: filename)
    }
    
    static let mockExample = Trick(
        id: 1,
        body: "Rust’s Hello world",
        code: "fn main() {\n    println!(\"Hello World!\");\n}",
        owner: UserResult.mockExample,
        datetime: "2022-01-18T20:22:07",
        highlighter: GlobalTrickItemDetail(id: 16, name: "ayu Dark"),
        programing_language: GlobalTrickItemDetail(id: 6, name: "rust"),
        code_frame: nil,
        type: TrickTypeClass(id: 1, name: "code", typeDescription: nil),
        views: 3,
        rates: 2,
        rate_state: 1,
        tags: ["Rust"],
        filename: "storage/upload/1/4d1ad4cf-46f4-41a0-80c5-5f50e6132a0a.png",
        quote: nil,
        image_size: CodePreviewDetail(width: 1024, height: 278)
    )
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

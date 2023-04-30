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
    let body: String?
    let code: String?
    let owner: UserResult
    let datetime: String
    let highlighter: GlobalTrickItemDetail?
    let programingLanguage: GlobalTrickItemDetail?
    let codeFrame: GlobalTrickItemDetail?
    let type: TrickTypeClass
    var views, rates, rateState: Int64
    let tags: [String?]
    let filename: String?
    let quote: Quote?
    let imageSize: CodePreviewDetail?
    let shareLink: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case body
        case code
        case owner
        case datetime
        case highlighter
        case programingLanguage = "programing_language"
        case codeFrame = "code_frame"
        case type
        case views
        case rates
        case rateState = "rate_state"
        case tags
        case filename
        case quote
        case imageSize = "image_size"
        case shareLink = "share_link"
    }
    
    var previewURL: URL? {
        return AppService().imageURL(url: filename)
    }
    
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self.datetime) ?? Date()
    }
}

extension Trick {
    static func placeHolder() -> Trick {
        Trick(
            id: 1,
            body: "Hello world! 😃",
            code: "fn main() {\n    println!(\"Hello Tricks :)\");\n}",
            owner: .placeHolder(),
            datetime: "2022-04-30T20:47:20",
            highlighter: .init(id: 17, name: "ayu Light"),
            programingLanguage: .init(id: 6, name: "Rust"),
            codeFrame: .init(id: 2, name: "Light"),
            type: .init(id: 1, name: "code", typeDescription: nil),
            views: 50,
            rates: 1_000,
            rateState: 1,
            tags: ["HelloWorld", "Rust", "Noob"],
            filename: "storage/upload/1/ce2d8302-5c66-4464-b452-8e12b3aafa8b.png",
            quote: nil,
            imageSize: .init(width: 1024, height: 278),
            shareLink: "https://tricks.aseman.io/tricks/1"
        )
    }
}

// MARK: - GlobalTrickItemDetail
struct GlobalTrickItemDetail: Codable {
    let id: Int
    let name: String
}

// MARK: - Quote
struct Quote: Codable {
    let trickID: Int
    let quote: String?
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

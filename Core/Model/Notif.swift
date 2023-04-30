//
//  Notif.swift
//  CodeTrick
//
//  Created by armin on 3/30/21.
//

import Foundation

// MARK: - Notification
public struct NotifResult: Codable {
    let result: [Notif]
    let status: Bool
}

// MARK: - Notification Item
public struct Notif: Codable {
    let id = UUID()
    let trick: NotifTrickResult?
    let notifyType: Int
    let datetime: String
    let user: UserResult
    let viewed: Int
    let comment: Comment?
    
    enum CodingKeys: String, CodingKey {
        case trick
        case notifyType = "notify_type"
        case datetime, user, viewed
        case comment
    }
    
    var type: NotifType {
        switch notifyType {
        case 1:
            return .like
        case 2:
            return .follow
        case 3:
            return .comment
        case 4:
            return .mention
        case 5:
            return .tagUpdate
        case 6:
            return .tips
        case 7:
            return .donate
        default:
            return .unknown
        }
    }
}

extension Notif {
    static func placeHolder(type: NotifType) -> Notif {
        switch type {
        case .like:
            return Notif(
                trick: .placeHolder(),
                notifyType: 1,
                datetime: "2022-04-05T01:37:40",
                user: .placeHolder(),
                viewed: 1,
                comment: nil
            )
        case .follow:
            return Notif(
                trick: nil,
                notifyType: 2,
                datetime: "2022-05-21T14:39:56",
                user: .placeHolder(),
                viewed: 1,
                comment: nil
            )
        case .comment:
            return Notif(
                trick: .placeHolder(),
                notifyType: 3,
                datetime: "2022-05-21T14:39:56",
                user: .placeHolder(),
                viewed: 1,
                comment: .placeHolder()
            )
        case .mention:
            return Notif(
                trick: .placeHolder(),
                notifyType: 4,
                datetime: "2022-05-21T14:39:56",
                user: .placeHolder(),
                viewed: 1,
                comment: .placeHolder()
            )
        case .tagUpdate:
            return Notif(
                trick: .placeHolder(),
                notifyType: 5,
                datetime: "2022-05-21T14:39:56",
                user: .placeHolder(),
                viewed: 1,
                comment: nil
            )
        case .tips:
            return Notif(
                trick: .placeHolder(),
                notifyType: 6,
                datetime: "2022-05-21T14:39:56",
                user: .placeHolder(),
                viewed: 0,
                comment: nil
            )
        case .donate:
            return Notif(
                trick: .placeHolder(),
                notifyType: 7,
                datetime: "2022-05-21T14:39:56",
                user: .placeHolder(),
                viewed: 0,
                comment: nil
            )
        case .unknown:
            return Notif(
                trick: .placeHolder(),
                notifyType: 999,
                datetime: "2022-05-21T14:39:56",
                user: .placeHolder(),
                viewed: 1,
                comment: nil
            )
        }
    }
    
    static let mockQuoteExample = Notif(
        trick: .placeHolder(),
        notifyType: 2,
        datetime: "2022-04-05T01:37:40",
        user: .placeHolder(),
        viewed: 1,
        comment: nil
    )
    
    static let mockCommentExample = Notif(
        trick: .placeHolder(),
        notifyType: 3,
        datetime: "2022-04-05T01:37:40",
        user: .placeHolder(),
        viewed: 1,
        comment: .placeHolder()
    )
}

public struct NotifTrickResult: Codable {
    let id: Int
    let body: String
    let code: String
    let owner: Int
    let datetime: String
    let highlighterID, programingLanguageID, codeFrameID, typeID: Int?
    let views, rates: Int
    let filename: String
}

extension NotifTrickResult {
    static func placeHolder() -> NotifTrickResult {
        NotifTrickResult(
            id: 1,
            body: "Hello world! 😃",
            code: "fn main() {\n    println!(\"Hello Tricks :)\");\n}",
            owner: 7,
            datetime: "2022-04-30T20:47:20",
            highlighterID: 4,
            programingLanguageID: 11,
            codeFrameID: 2,
            typeID: 1,
            views: 2,
            rates: 2,
            filename: "storage/upload/1/efb5ca7f-7f37-4f17-aefd-dd6f8d2b7108.png"
        )
    }
}

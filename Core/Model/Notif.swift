//
//  Notif.swift
//  CodeTrick
//
//  Created by armin on 3/30/21.
//

import Foundation

// MARK: - Notification
struct NotifResult: Codable {
    let result: [Notif]
    let status: Bool
}

// MARK: - Notification Item
struct Notif: Codable {
    let id = UUID()
    let trick: NotifTrickResult
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
    
    static let mockLikeExample = Notif(
        trick: NotifTrickResult.mockExample,
        notifyType: 1,
        datetime: "2022-04-05T01:37:40",
        user: UserResult.mockExample,
        viewed: 1,
        comment: nil
    )
    
    static let mockQuoteExample = Notif(
        trick: NotifTrickResult.mockExample,
        notifyType: 2,
        datetime: "2022-04-05T01:37:40",
        user: UserResult.mockExample,
        viewed: 1,
        comment: nil
    )
    
    static let mockCommentExample = Notif(
        trick: NotifTrickResult.mockExample,
        notifyType: 3,
        datetime: "2022-04-05T01:37:40",
        user: UserResult.mockExample,
        viewed: 1,
        comment: Comment.mockExample
    )
}

struct NotifTrickResult: Codable {
    let id: Int
    let body: String
    let code: String
    let owner: Int
    let datetime: String
    let highlighterID, programingLanguageID, codeFrameID, typeID: Int?
    let views, rates: Int
    let filename: String
    
    static let mockExample = NotifTrickResult(
        id: 123,
        body: "Its a test",
        code: "PostTrickRequest {\n    id: postReq\n    allowGlobalBusy: GlobalSettings.mobileView\n    onSuccessfull: reloadTimer.restart()\n}",
        owner: 7,
        datetime: "2022-04-04T15:34:39",
        highlighterID: 4,
        programingLanguageID: 11,
        codeFrameID: 2,
        typeID: 1,
        views: 2,
        rates: 2,
        filename: "storage/upload/1/efb5ca7f-7f37-4f17-aefd-dd6f8d2b7108.png"
    )
}


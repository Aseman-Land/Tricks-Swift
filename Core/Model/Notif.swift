//
//  Notif.swift
//  CodeTrick
//
//  Created by armin on 3/30/21.
//

import Foundation

// MARK: - Notification
struct Notif: Codable {
    let result: [NotifResult]
    let status: Bool
}

// MARK: - Notification Item
struct NotifResult: Codable {
    let id = UUID()
    let trick: NotifTrickResult
    let notifyType: Int
    let datetime: String
    let user: UserResult
    let viewed: Int
    
    enum CodingKeys: String, CodingKey {
        case trick
        case notifyType = "notify_type"
        case datetime, user, viewed
    }
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
}

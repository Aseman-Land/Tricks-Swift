//
//  Comment.swift
//  Tricks
//
//  Created by Armin on 5/17/22.
//

import Foundation

struct Comment: Codable {
    let id: Int
    let userID: Int
    let trickID: Int?
    let datetime: String
    let message: String?
    let deleted: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case trickID = "trick_id"
        case datetime
        case message
        case deleted
    }
    
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self.datetime) ?? Date()
    }
}

extension Comment {
    static func placeHolder() -> Comment {
        Comment(
            id: 1,
            userID: 1,
            trickID: 1,
            datetime: "2021-01-10T10:10:10",
            message: "Here is the message to crazy ones",
            deleted: 0
        )
    }
}

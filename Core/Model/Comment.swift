//
//  Comment.swift
//  Tricks
//
//  Created by Armin on 5/17/22.
//

import Foundation

struct Comment: Codable {
    let id: Int
    let user_id: Int
    let trick_id: Int?
    let datetime: String
    let message: String?
    let deleted: Int?
    
    static let mockExample = Comment(
        id: 47,
        user_id: 68,
        trick_id: 131,
        datetime: "2022-05-14T22:52:05",
        message: "منم اولین فلاتر دولوپر",
        deleted: 0
    )
}

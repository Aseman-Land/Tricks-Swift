//
//  Tags.swift
//  CodeTrick
//
//  Created by armin on 3/8/21.
//

import Foundation

// MARK: - Tags
struct TagsResult: Codable {
    let result: [Tags]
    let status: Bool
}

// MARK: - Result
struct Tags: Codable {
    let tag: String
    let count, followers: Int
}


//
//  Tags.swift
//  CodeTrick
//
//  Created by armin on 3/8/21.
//

import Foundation

// MARK: - Tags
struct Tags: Codable {
    let result: [TagsResult]
    let status: Bool
}

// MARK: - Result
struct TagsResult: Codable {
    let tag: String
    let count, followers: Int
}


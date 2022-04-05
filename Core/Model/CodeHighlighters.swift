//
//  CodeHighlighters.swift
//  Tricks
//
//  Created by Armin on 4/5/22.
//

import Foundation

struct Highlighters: Codable {
    let result: [Highlighter]
    let status: Bool
}

struct Highlighter: Codable {
    let id: Int
    let name: String
    let logical_name: String
    let default_frame_id: Int
}

struct CodeFrames: Codable {
    let result: [CodeFrame]
    let status: Bool
}

struct CodeFrame: Codable {
    let id: Int
    let name: String
    let logical_name: String
}

struct ProgrammingLanguages: Codable {
    let result: [ProgrammingLanguage]
    let status: Bool
}

struct ProgrammingLanguage: Codable {
    let id: Int
    let name: String
    let logical_name: String
}

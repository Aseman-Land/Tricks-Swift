//
//  CodeHighlighterService.swift
//  Tricks
//
//  Created by Armin on 4/5/22.
//

import Foundation

protocol CodeHighlighterServiceable {
    func getHighlighters(token: String) async throws -> Highlighters
    func getCodeFrames(token: String) async throws -> CodeFrames
    func getProgrammingLanguages(token: String) async throws -> ProgrammingLanguages
}

struct CodeHighlighterService: HTTPClient, CodeHighlighterServiceable {
    func getHighlighters(token: String) async throws -> Highlighters {
        return try await sendRequest(
            endpoint: CodeHighlighterEndpoint.getHighlighters(token: token),
            responseModel: Highlighters.self
        )
    }
    
    func getCodeFrames(token: String) async throws -> CodeFrames {
        return try await sendRequest(
            endpoint: CodeHighlighterEndpoint.getCodeFrames(token: token),
            responseModel: CodeFrames.self
        )
    }
    
    func getProgrammingLanguages(token: String) async throws -> ProgrammingLanguages {
        return try await sendRequest(
            endpoint: CodeHighlighterEndpoint.getProgrammingLanguages(token: token),
            responseModel: ProgrammingLanguages.self
        )
    }
}

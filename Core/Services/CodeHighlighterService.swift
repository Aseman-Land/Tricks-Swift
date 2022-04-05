//
//  CodeHighlighterService.swift
//  Tricks
//
//  Created by Armin on 4/5/22.
//

import Foundation

protocol CodeHighlighterServiceable {
    func getHighlighters(token: String) async throws -> Result<Highlighters, RequestError>
    func getCodeFrames(token: String) async throws -> Result<CodeFrames, RequestError>
    func getProgrammingLanguages(token: String) async throws -> Result<ProgrammingLanguages, RequestError>
}

struct CodeHighlighterService: HTTPClient, CodeHighlighterServiceable {
    func getHighlighters(token: String) async throws -> Result<Highlighters, RequestError> {
        return try await sendRequest(
            endpoint: CodeHighlighterEndpoint.getHighlighters(token: token),
            responseModel: Highlighters.self
        )
    }
    
    func getCodeFrames(token: String) async throws -> Result<CodeFrames, RequestError> {
        return try await sendRequest(
            endpoint: CodeHighlighterEndpoint.getCodeFrames(token: token),
            responseModel: CodeFrames.self
        )
    }
    
    func getProgrammingLanguages(token: String) async throws -> Result<ProgrammingLanguages, RequestError> {
        return try await sendRequest(
            endpoint: CodeHighlighterEndpoint.getProgrammingLanguages(token: token),
            responseModel: ProgrammingLanguages.self
        )
    }
}

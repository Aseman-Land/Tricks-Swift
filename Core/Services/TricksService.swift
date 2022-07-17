//
//  TricksService.swift
//  Tricks
//
//  Created by Armin on 3/1/22.
//

import Foundation

protocol TricksServiceable {
    func globalTricks(token: String, limit: Int, offset: Int) async throws -> Result<Tricks, RequestError>
    
    func myTimelineTricks(token: String, limit: Int, offset: Int) async throws -> Result<Tricks, RequestError>
    
    func profileTricks(userID: String, token: String, limit: Int, offset: Int) async throws -> Result<Tricks, RequestError>
    
    func getTrick(trickID: Int, token: String) async throws -> Result<Tricks, RequestError>
    
    func postTrick(
        comment: String,
        code: String,
        tags: [String],
        highlighterID: Int,
        programmingLanguageID: Int,
        typeID: Int,
        token: String
    ) async throws -> Result<Tricks, RequestError>
    
    func retrickPost(
        trickID: Int,
        quote: String,
        token: String
    ) async throws -> Result<Tricks, RequestError>
    
    func deleteTrickPost(trickID: Int, token: String) async throws -> Result<GlobalResponse, RequestError>
    
    func addRate(tagID: Int, rate: Int, token: String) async throws -> Result<Tricks, RequestError>
    
    func addView(tricksIDs: [Int], token: String) async throws -> Result<Bool, RequestError>
}

struct TricksService: HTTPClient, TricksServiceable {
    func globalTricks(token: String, limit: Int = 20, offset: Int = 0) async throws -> Result<Tricks, RequestError> {
        return try await sendRequest(
            endpoint: TricksEndpoint.globalTricks(token: token, limit: limit, offset: offset),
            responseModel: Tricks.self
        )
    }
    
    func myTimelineTricks(token: String, limit: Int = 20, offset: Int = 0) async throws -> Result<Tricks, RequestError> {
        return try await sendRequest(
            endpoint: TricksEndpoint.myTimelineTricks(token: token, limit: limit, offset: offset),
            responseModel: Tricks.self
        )
    }
    
    func getTrick(trickID: Int, token: String) async throws -> Result<Tricks, RequestError> {
        return try await sendRequest(
            endpoint: TricksEndpoint.getTrick(trickID: trickID, token: token),
            responseModel: Tricks.self
        )
    }
    
    func profileTricks(userID: String, token: String, limit: Int = 20, offset: Int = 0) async throws -> Result<Tricks, RequestError> {
        return try await sendRequest(
            endpoint: TricksEndpoint.profiletricks(userID: userID, token: token, limit: limit, offset: offset),
            responseModel: Tricks.self
        )
    }
    
    func postTrick(comment: String, code: String, tags: [String], highlighterID: Int, programmingLanguageID: Int, typeID: Int, token: String) async throws -> Result<Tricks, RequestError> {
        return try await sendRequest(
            endpoint: TricksEndpoint.postTrick(comment: comment, code: code, tags: tags, highlighterID: highlighterID, programmingLanguageID: programmingLanguageID, typeID: typeID, token: token),
            responseModel: Tricks.self
        )
    }
    
    func retrickPost(trickID: Int, quote: String, token: String) async throws -> Result<Tricks, RequestError> {
        return try await sendRequest(
            endpoint: TricksEndpoint.retrickPost(trickID: trickID, quote: quote, token: token),
            responseModel: Tricks.self
        )
    }
    
    func deleteTrickPost(trickID: Int, token: String) async throws -> Result<GlobalResponse, RequestError> {
        return try await sendRequest(
            endpoint: TricksEndpoint.deleteTrickPost(trickID: trickID, token: token),
            responseModel: GlobalResponse.self
        )
    }
    
    func addRate(tagID: Int, rate: Int, token: String) async throws -> Result<Tricks, RequestError> {
        return try await sendRequest(
            endpoint: TricksEndpoint.addRate(tagID: tagID, rate: rate, token: token),
            responseModel: Tricks.self
        )
    }
    
    func addView(tricksIDs: [Int], token: String) async throws -> Result<Bool, RequestError> {
        return try await sendRequest(
            endpoint: TricksEndpoint.addView(tricksIDs: tricksIDs, token: token),
            responseModel: Bool.self
        )
    }
}

//
//  TagsService.swift
//  Tricks
//
//  Created by Armin on 4/10/22.
//

import Foundation

protocol TagsServiceable {
    func globalTags(token: String) async throws -> Result<Tags, RequestError>
    
    func myTags(token: String) async throws -> Result<Tags, RequestError>
    
    func getTagsTricks(tagName: String, token: String) async throws -> Result<Tags, RequestError>
    
    func followTag(tagName: String, token: String) async throws -> Result<GlobalResponse, RequestError>
    
    func unfollowTag(tagName: String, token: String) async throws -> Result<GlobalResponse, RequestError>
    
    func batchFollowTags(tags: [String], token: String) async throws -> Result<GlobalResponse, RequestError>
}

struct TagsService: HTTPClient, TagsServiceable {
    func globalTags(token: String) async throws -> Result<Tags, RequestError> {
        return try await sendRequest(
            endpoint: TagsEndpoint.globalTags(token: token),
            responseModel: Tags.self
        )
    }
    
    func myTags(token: String) async throws -> Result<Tags, RequestError> {
        return try await sendRequest(
            endpoint: TagsEndpoint.myTags(token: token),
            responseModel: Tags.self
        )
    }
    
    func getTagsTricks(tagName: String, token: String) async throws -> Result<Tags, RequestError> {
        return try await sendRequest(
            endpoint: TagsEndpoint.getTagsTricks(tagName: tagName, token: token),
            responseModel: Tags.self
        )
    }
    
    func followTag(tagName: String, token: String) async throws -> Result<GlobalResponse, RequestError> {
        return try await sendRequest(
            endpoint: TagsEndpoint.followTag(tagName: tagName, token: token),
            responseModel: GlobalResponse.self
        )
    }
    
    func unfollowTag(tagName: String, token: String) async throws -> Result<GlobalResponse, RequestError> {
        return try await sendRequest(
            endpoint: TagsEndpoint.unfollowTag(tagName: tagName, token: token),
            responseModel: GlobalResponse.self
        )
    }
    
    func batchFollowTags(tags: [String], token: String) async throws -> Result<GlobalResponse, RequestError> {
        return try await sendRequest(
            endpoint: TagsEndpoint.batchFollowTags(tags: tags, token: token),
            responseModel: GlobalResponse.self
        )
    }
}

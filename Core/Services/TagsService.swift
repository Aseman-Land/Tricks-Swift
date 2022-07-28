//
//  TagsService.swift
//  Tricks
//
//  Created by Armin on 4/10/22.
//

import Foundation

protocol TagsServiceable {
    func globalTags(token: String) async throws -> Tags
    
    func myTags(token: String) async throws -> Tags
    
    func getTagsTricks(tagName: String, token: String) async throws -> Tags
    
    func followTag(tagName: String, token: String) async throws -> GlobalResponse
    
    func unfollowTag(tagName: String, token: String) async throws -> GlobalResponse
    
    func batchFollowTags(tags: [String], token: String) async throws -> GlobalResponse
}

struct TagsService: HTTPClient, TagsServiceable {
    func globalTags(token: String) async throws -> Tags {
        return try await sendRequest(
            endpoint: TagsEndpoint.globalTags(token: token),
            responseModel: Tags.self
        )
    }
    
    func myTags(token: String) async throws -> Tags {
        return try await sendRequest(
            endpoint: TagsEndpoint.myTags(token: token),
            responseModel: Tags.self
        )
    }
    
    func getTagsTricks(tagName: String, token: String) async throws -> Tags {
        return try await sendRequest(
            endpoint: TagsEndpoint.getTagsTricks(tagName: tagName, token: token),
            responseModel: Tags.self
        )
    }
    
    func followTag(tagName: String, token: String) async throws -> GlobalResponse {
        return try await sendRequest(
            endpoint: TagsEndpoint.followTag(tagName: tagName, token: token),
            responseModel: GlobalResponse.self
        )
    }
    
    func unfollowTag(tagName: String, token: String) async throws -> GlobalResponse {
        return try await sendRequest(
            endpoint: TagsEndpoint.unfollowTag(tagName: tagName, token: token),
            responseModel: GlobalResponse.self
        )
    }
    
    func batchFollowTags(tags: [String], token: String) async throws -> GlobalResponse {
        return try await sendRequest(
            endpoint: TagsEndpoint.batchFollowTags(tags: tags, token: token),
            responseModel: GlobalResponse.self
        )
    }
}

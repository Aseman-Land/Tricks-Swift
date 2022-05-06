//
//  TagsEndpoint.swift
//  Tricks
//
//  Created by Armin on 4/10/22.
//

import Foundation

enum TagsEndpoint {
    case globalTags(token: String)
    
    case myTags(token: String)
    
    case getTagsTricks(
        tagName: String,
        token: String
    )
    
    case followTag(
        tagName: String,
        token: String
    )
    
    case unfollowTag(
        tagName: String,
        token: String
    )
    
    case batchFollowTags(
        tags: [String],
        token: String
    )
}

extension TagsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .globalTags(_):
            return "/api/v1/tags"
        case .myTags(_):
            return "/api/v1/users/me/tags"
        case .getTagsTricks(let tagName, _):
            return "/api/v1/tags/\(tagName)/tricks"
        case .followTag(_, _):
            return "/api/v1/users/me/tags"
        case .unfollowTag(let tagName, _):
            return "/api/v1/users/me/tags/\(tagName)"
        case .batchFollowTags(_, _):
            return "/api/v1/users/me/tags/batch"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .globalTags(_):
            return .get
        case .myTags(_):
            return .get
        case .getTagsTricks(_, _):
            return .get
        case .followTag(_, _):
            return .post
        case .unfollowTag(_, _):
            return .delete
        case .batchFollowTags(_, _):
            return .post
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .globalTags(let token),
             .myTags(let token),
             .getTagsTricks(_ , let token),
             .followTag(_, let token),
             .unfollowTag(_, let token),
             .batchFollowTags(_ , let token):
            return [
                "Authorization": token,
                "Content-Type":"\(HTTPContentType.applicationJSON); \(HTTPContentType.charsetUTF8)",
            ]
            
        }
    }
    
    var urlParams: [URLQueryItem]? {
        return nil
    }
    
    var body: [String : Any]? {
        switch self {
            case .globalTags(_),
                 .myTags(_),
                 .getTagsTricks(_, _),
                 .unfollowTag(_, _):
            return nil
        case .followTag(let tag, _):
            return [
                "tag": tag
            ]
        case .batchFollowTags(let tags, _):
            return [
                "tags": tags
            ]
        }
    }
}

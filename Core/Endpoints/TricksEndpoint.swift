//
//  TricksEndpoint.swift
//  Tricks
//
//  Created by Armin on 3/1/22.
//

import Foundation

enum TricksEndpoint {
    // MARK: - Rates
    case addRate(
        tagID: Int,
        rate: Int,
        token: String
    )
    
    case globalTricks(
        token: String
    )
    
    case myTimelineTricks(
        token: String
    )
    
    case getTrick(
        trickID: Int,
        token: String
    )
    
    case profiletricks(
        userID: String,
        token: String
    )
    
    case postTrick(
        comment: String,
        code: String,
        tags: [String],
        highlighterID: Int,
        programmingLanguageID: Int,
        typeID: Int,
        token: String
    )
    
    case retrickPost(
        trickID: Int,
        quote: String,
        token: String
    )
    
    case deleteTrickPost(
        trickID: Int,
        token: String
    )
    
    case addView(
        tricksIDs: [Int],
        token: String
    )
}

extension TricksEndpoint: Endpoint {
    var path: String {
        switch self {
        case .addRate(tagID: let tagID, rate: _, _):
            return "/api/v1/tricks/\(tagID)/rates"
        case .globalTricks(_):
            return "/api/v1/tricks"
        case .myTimelineTricks(_):
            return "/api/v1/users/me/timeline"
        case .getTrick(trickID: let trickID, _):
            return "/api/v1/tricks/\(trickID)"
        case .profiletricks(userID: let userID, _):
            return "/api/v1/users/\(userID)/tricks"
        case .postTrick(_, _, _, _, _, _, _):
            return "/api/v1/tricks"
        case .retrickPost(_, _, _):
            return "/api/v1/retricks"
        case .deleteTrickPost(trickID: let trickID, _):
            return "/api/v1/tricks/\(trickID)"
        case .addView(_, _):
            return "/api/v1/tricks/views"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .globalTricks(_),
             .myTimelineTricks(_),
             .getTrick(_, _),
             .profiletricks(_, _):
            return .get
            
        case .postTrick(_, _, _, _, _, _, _),
             .retrickPost(_, _, _),
             .addRate(_, _, _),
             .addView(_, _):
            return .post
            
        case .deleteTrickPost(_, _):
            return .delete
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .globalTricks(token: let token),
             .myTimelineTricks(token: let token),
             .getTrick(_, token: let token),
             .profiletricks(_, token: let token),
             .postTrick(_, _, _, _, _, _, token: let token),
             .retrickPost(_, _, token: let token),
             .deleteTrickPost(_, token: let token),
             .addRate(_, _, token: let token),
             .addView(_, token: let token):
            return [
                "Authorization": token,
                "Content-Type":"application/json; charset=utf-8",
            ]
        }
    }
    
    var urlParams: [URLQueryItem]? {
        return nil
    }
    
    var body: [String : Any]? {
        switch self {
        case .postTrick(comment: let comment, code: let code, tags: let tags, highlighterID: let highlighterID, programmingLanguageID: let programmingLanguageID, typeID: let typeID, _):
            return [
                "body": comment,
                "code": code,
                "tags": tags,
                "highlighter_id": highlighterID,
                "programing_language_id": programmingLanguageID,
                "type_id": typeID
            ]
        case .retrickPost(trickID: let trickID, quote: let quote, _):
            return [
                "quoted_trick_id": trickID,
                "quoted_text": quote,
            ]
        case .addRate(_, rate: let rate, _):
            return ["rate": rate]
        case .addView(tricksIDs: let tricksIDs, _):
            return ["tricks": tricksIDs]
            
        default:
            return nil
        }
    }
}

//
//  UsersEndPoint.swift
//  Tricks
//
//  Created by Armin on 5/2/22.
//

import Foundation

enum UsersEndpoint {
    // MARK: - Global
    case getUser(
        userID: String,
        token: String
    )
    
    case searchUsers(
        keyword: String,
        token: String,
        offset: Int? = nil,
        limit: Int? = nil
    )
    
    case getMe(
        token: String
    )
    
    case editMe(
        username: String?,
        fullname: String?,
        password: String?,
        current_password: String?,
        token: String
    )
    
     case deleteMe(
        token: String
     )
    
    // MARK: - Followers
    case getMyFollowers(
        token: String
    )
    
    case getUserFollowers(
        userID: String,
        token: String
    )
    
    // MARK: - Followings
    case getMyFollowings(
        token: String
    )
    
    case getUserFollowings(
        userID: String,
        token: String
    )
    
    case followSomeone(
        userID: String,
        token: String
    )
    
    case unfollowSomeone(
        userID: String,
        token: String
    )
}

extension UsersEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getUser(let userID, _):
            return "/api/v1/users/\(userID)"
        case .searchUsers(_, _, _, _):
            return "/api/v1/users"
        case .getMe(_):
            return "/api/v1/users/me"
        case .editMe(_, _, _, _, _):
            return "/api/v1/users/me"
        case .deleteMe(_):
            return "/api/v1/users/me"
            
        case .getMyFollowers(_):
            return "/api/v1/users/me/followers"
        case .getUserFollowers(let userID, _):
            return "/api/v1/users/\(userID)/followers"
            
        case .getMyFollowings(_):
            return "/api/v1/users/me/followings"
        case .getUserFollowings(let userID, _):
            return "/api/v1/users/\(userID)/followings"
        case .followSomeone(_, _):
            return "/api/v1/users/me/followings"
        case .unfollowSomeone(let userID, _):
            return "/api/v1/users/me/followings/\(userID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getUser(_, _),
             .searchUsers(_, _, _, _),
             .getMe(_),
             .getMyFollowers(_),
             .getUserFollowers(_, _),
             .getMyFollowings(_),
             .getUserFollowings(_, _):
            return .get
        case .followSomeone(_, _):
            return .post
        case .editMe(_, _, _, _, _):
            return .patch
        case .deleteMe(_),
             .unfollowSomeone(_, _):
            return .delete
        }
    }

    var header: [String : String]? {
        switch self {
        case .getUser(_, let token),
             .getMe(let token),
             .searchUsers(_, let token, _, _),
             .editMe(_, _, _, _, let token),
             .deleteMe(let token),
             .getMyFollowers(let token),
             .getUserFollowers(_, let token),
             .getMyFollowings(let token),
             .getUserFollowings(_, let token),
             .followSomeone(_, let token),
             .unfollowSomeone(_, let token):
            
            return [
                "Authorization": token,
                "Content-Type":"application/json; charset=utf-8",
            ]
        }
    }

    var urlParams: [URLQueryItem]? {
        switch self {
        case .searchUsers(let keyword, _, let offset, let limit):
            var queryItems = [URLQueryItem]()
            
            if let offset = offset {
                queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
            }
            
            if let limit = limit {
                queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
            }
            
            queryItems.append(URLQueryItem(name: "keyword", value: keyword))
            
            return queryItems
        default:
            return nil
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .editMe(let username , let fullname, let password, let current_password, _):
            var editBody = [String : String]()

            if let username = username {
                editBody["username"] = username
            }

            if let fullname = fullname {
                editBody["fullname"] = fullname
            }

            if let password = password {
                editBody["password"] = password
            }

            if let current_password = current_password {
                editBody["current_password"] = current_password
            }

            return editBody
            
        case .followSomeone(let userID, _):
            return [
                "user_id": userID
            ]
        default:
            return nil
        }
    }
}

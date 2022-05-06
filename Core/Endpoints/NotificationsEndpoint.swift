//
//  NotificationsEndpoint.swift
//  Tricks
//
//  Created by Armin on 4/19/22.
//

import Foundation

enum NotificationsEndpoint {
    case getNotifications(
        token: String,
        offset: Int? = nil,
        limit: Int? = nil
    )
    
    case dismissNotifications(
        until: String,
        token: String
    )
}

extension NotificationsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getNotifications(_, _, _):
            return "/api/v1/notifications"
        case .dismissNotifications(_, _):
            return "/api/v1/notifications/dismiss"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNotifications(_, _, _):
            return .get
        case .dismissNotifications(_, _):
            return .post
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getNotifications(let token, _, _),
             .dismissNotifications(_, let token):
            return [
                "Authorization": token,
                "Content-Type":"\(HTTPContentType.applicationJSON); \(HTTPContentType.charsetUTF8)",
            ]
        }
    }
    
    var urlParams: [URLQueryItem]? {
        switch self {
        case .getNotifications(_, let offset, let limit):
            var queryItems = [URLQueryItem]()
            
            if let offset = offset {
                queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
            }
            
            if let limit = limit {
                queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
            }
            
            return queryItems
        default:
            return nil
        }
        
    }
    
    var body: [String : Any]? {
        switch self {
        case .getNotifications(_, _, _):
            return nil
        case .dismissNotifications(let until, _):
            return ["until": until]
        }
    }
}

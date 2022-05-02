//
//  NotificationsEndpoint.swift
//  Tricks
//
//  Created by Armin on 4/19/22.
//

import Foundation

enum NotificationsEndpoint {
    case getNotifications(token: String)
    
    case dismissNotifications(until: String, token: String)
}

extension NotificationsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getNotifications(_):
            return "/api/v1/notifications"
        case .dismissNotifications(_, _):
            return "/api/v1/notifications/dismiss"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNotifications(_):
            return .get
        case .dismissNotifications(_, _):
            return .post
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getNotifications(let token), .dismissNotifications(_, let token):
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
        case .getNotifications(_):
            return nil
        case .dismissNotifications(let until, _):
            return ["until": until]
        }
    }
}

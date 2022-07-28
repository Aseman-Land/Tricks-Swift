//
//  NotificationService.swift
//  Tricks
//
//  Created by Armin on 4/19/22.
//

import Foundation

protocol NotificationServiceable {
    func getNotifications(token: String, offset: Int?, limit: Int?) async throws -> NotifResult
    
    func dismissNotifications(until: String, token: String) async throws -> NotifResult
}

struct NotificationService: HTTPClient, NotificationServiceable {
    func getNotifications(
        token: String,
        offset: Int? = nil,
        limit: Int? = nil
    ) async throws -> NotifResult {
        return try await sendRequest(
            endpoint: NotificationsEndpoint.getNotifications(token: token, offset: offset, limit: limit),
            responseModel: NotifResult.self
        )
    }
    
    func dismissNotifications(
        until: String,
        token: String
    ) async throws -> NotifResult {
        return try await sendRequest(
            endpoint: NotificationsEndpoint.dismissNotifications(until: until, token: token),
            responseModel: NotifResult.self
        )
    }
}

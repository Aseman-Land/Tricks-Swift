//
//  NotifType.swift
//  Tricks
//
//  Created by Armin on 4/30/23.
//

import Foundation

//  Notification types:
//
//  Like = 1
//  Follow = 2
//  Comment = 3
//  Mention = 4
//  TagUpdate = 5
//  Tips = 6
//  Donate = 7

public enum NotifType: CaseIterable {
    case like
    case follow
    case comment
    case mention
    case tagUpdate
    case tips
    case donate
    case unknown
}

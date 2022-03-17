//
//  Sharer.swift
//  Tricks (iOS)
//
//  Created by Armin on 3/17/22.
//

import SwiftUI

public protocol Sharer {
    var type: UIActivity.ActivityType { get }
    var title: String { get }
    var image: UIImage { get }
    func canPerform(with items: [Any]) -> Bool
    var uiActivity: UIActivity { get }
}

public protocol SharerWithAction: Sharer {
    func perform(with items: [Any])
}

public protocol SharerWithView: Sharer {
    associatedtype SharerView: View
    func view(for items: [Any]) -> SharerView
}

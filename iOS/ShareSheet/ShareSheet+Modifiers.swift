//
//  ShareSheet+Modifiers.swift
//  Tricks (iOS)
//
//  Created by Armin on 3/17/22.
//

import UIKit

extension ShareSheet {
    
    /// Enables the caller to know when the user has completed their interaction with the Share Sheet
    /// - Parameter handler: The function that handles when the user has completed their interaction with the share sheet
    public func onComplete(_ handler: @escaping (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ activityError: Error?) -> Void) -> Self {
        var copy = self
        copy.onComplete = handler
        return copy
    }
}

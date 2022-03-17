//
//  ShareSheet+UIKitRepresentable.swift
//  Tricks (iOS)
//
//  Created by Armin on 3/17/22.
//

import SwiftUI

extension ShareSheet: UIViewControllerRepresentable {
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: customActivities?.map { $0.uiActivity })
    }
    
    public func updateUIViewController(_ viewController: UIActivityViewController, context: Context) {
        viewController.completionWithItemsHandler = onComplete
    }
}

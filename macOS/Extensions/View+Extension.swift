//
//  View+Extension.swift
//  Tricks
//
//  Created by Armin on 4/4/22.
//

import SwiftUI

extension View {
    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        let window = NSWindow(contentViewController: controller)
        window.contentViewController = controller
        window.title = title
        window.makeKeyAndOrderFront(sender)
        return window
    }
}

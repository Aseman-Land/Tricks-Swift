//
//  View+Extension.swift
//  Tricks
//
//  Created by Armin on 4/4/22.
//

import SwiftUI

extension View {
    @discardableResult
    func openInWindow(title: String, sender: Any?, transparentTitlebar: Bool = false) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        let window = NSWindow(contentViewController: controller)
        window.contentViewController = controller
        window.title = title
        window.titlebarAppearsTransparent = transparentTitlebar
        window.titleVisibility = transparentTitlebar ? .hidden : .visible
        window.styleMask.insert(transparentTitlebar ? .fullSizeContentView : .titled)
        window.makeKeyAndOrderFront(sender)
        return window
    }
}

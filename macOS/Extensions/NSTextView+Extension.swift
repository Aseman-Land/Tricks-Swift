//
//  NSTextView+Extension.swift
//  Tricks (macOS)
//
//  Created by Armin on 3/4/22.
//

import AppKit

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }

    }
}

//
//  NSImage+Extensions.swift
//  Retrick (macOS)
//
//  Created by armin on 3/6/21.
//

import SwiftUI

extension NSBitmapImageRep {
    var jpeg: Data? { representation(using: .jpeg, properties: [:]) }
}
extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}
extension NSImage {
    var jpeg: Data? { tiffRepresentation?.bitmap?.jpeg }
}

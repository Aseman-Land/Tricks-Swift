//
//  View+Extension.swift
//  Tricks
//
//  Created by Armin on 1/6/23.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

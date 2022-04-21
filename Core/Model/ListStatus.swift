//
//  ListStatus.swift
//  Tricks
//
//  Created by Armin on 4/21/22.
//

import Foundation

enum ListStatus {
    case loading
    case fullList
    case emptyList
    case errorLoading(String)
}

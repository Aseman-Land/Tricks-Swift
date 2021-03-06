//
//  HapticGenerator.swift
//  Tricks
//
//  Created by Armin on 4/8/22.
//

import UIKit

class HapticGenerator {
    
    static let shared = HapticGenerator()
    
    func soft() {
        let hapticGenerator = UIImpactFeedbackGenerator(style: .soft)
        hapticGenerator.impactOccurred()
    }
    
    func light() {
        let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
        hapticGenerator.impactOccurred()
    }
    
    func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
}

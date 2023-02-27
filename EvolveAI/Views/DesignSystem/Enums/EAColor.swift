//
//  EAColor.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/21/23.
//

import Foundation
import UIKit

/// Custom colors for this application
enum EAColor: String {
    case pastelRed = "#ffb3ba"
    case pastelOrange = "#ffdfba"
    case pastelYellow = "#ffffba"
    case pastelGreen = "#baffc9"
    case pastelBlue = "#bae1ff"

    case background = "#0B89FC"
    
    case label = "#FFFFFF"
    case secondaryLabel = "SECONDARY LABEL"
    
    case accent = "#FF8600"
    
    case disabled = "#B4B4B4"

    case success = "#00FF31"
    case failure = "#db001a"
    case action = "#ffffff"

    /// Returns the UIColor
    var uiColor: UIColor {
//        return UIColor(hex: self.rawValue) ?? .black

        switch self {
        case .secondaryLabel:
            return EAColor.label.darken(by: 10)

        default:
            return UIColor(hex: self.rawValue) ?? .black
        }
    }

    func darken(by factor: CGFloat = 60) -> UIColor {
        return self.uiColor.darker(by: factor) ?? .black
    }

    // MARK: - Static Variables

    /// The colors that goals can be
    static var goalColors: [EAColor] {
        return [.pastelRed, .pastelOrange, .pastelYellow, .pastelGreen, .pastelBlue]
    }
}

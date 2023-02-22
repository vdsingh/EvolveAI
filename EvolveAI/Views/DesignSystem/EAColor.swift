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

    case background = "#C9B6E4"
    case label = "LABEL"

    case success = "#02b529"
    case failure = "#db001a"

    /// Returns the UIColor
    var uiColor: UIColor {
        switch self {
        case .label:
            return EAColor.background.darken(by: 60)

        default:
            return UIColor(hex: self.rawValue) ?? .black
        }
    }

    func darken(by factor: CGFloat) -> UIColor {
        return self.uiColor.darker(by: factor) ?? .black
    }

    // MARK: - Static Variables

    /// The colors that goals can be
    static var goalColors: [EAColor] {
        return [.pastelRed, .pastelOrange, .pastelYellow, .pastelGreen, .pastelBlue]
    }
}

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
    
    /// Returns the UIColor
    var uiColor: UIColor {
        return UIColor(hex: self.rawValue) ?? .black
    }
    
    // MARK: - Static Variables
    
    /// The colors that goals can be
    static var goalColors: [EAColor] {
        return [.pastelRed, .pastelOrange, .pastelYellow, .pastelGreen, .pastelBlue]
    }
}

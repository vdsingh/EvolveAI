//
//  Extensions.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/16/23.
//

import Foundation
import UIKit

extension String {

    /// Returns the number of tokens
    /// - Parameter charSet: The CharacterSet describing how to separate tokens
    /// - Returns: The number of tokens as an Int
    public func numTokens(separatedBy charSet: CharacterSet) -> Int {
        let components = self.components(separatedBy: charSet)
        return components.count
    }
}

extension UIColor {

    /// Generates a random opaque color
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }

    static var EAGreen: UIColor { return UIColor(red: 1, green: 0, blue: 0, alpha: 1) }

    /// Initializes a UIColor using a hex string
    /// - Parameter hex: The hex String
    public convenience init?(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    /// Converts a UIColor to a hex String
    /// - Parameter color: the color to convert
    /// - Returns: A hex String representing the color
    public func hexStringFromColor() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
    }
}

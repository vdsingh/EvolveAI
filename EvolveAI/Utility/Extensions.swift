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
    func numTokens(separatedBy charSet: CharacterSet) -> Int {
        let components = self.components(separatedBy: charSet)
        return components.count
    }

    /// Constructs a String where non-filler words such as "the" and "to" are capitalized
    /// - Returns: a String where non-filler words such as "the" and "to" are capitalized
    func capitalizeNonFillerWords() -> String {
        let excludedWords = [
            "the",
            "to"
        ]
        var newStr: String = ""
        let stringArray: [String] = self.components(separatedBy: " ")
        for str in stringArray {
            if excludedWords.contains(str) {
                newStr.append("\(str) ")
            } else {
                newStr.append("\(str.capitalized) ")
            }
        }

        // Removes the last space
        newStr.removeLast()
        return newStr
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
        return hexString
    }
}

extension UIColor {
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 60.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: min(red + percentage/100, 1.0),
                green: min(green + percentage/100, 1.0),
                blue: min(blue + percentage/100, 1.0),
                alpha: alpha
            )
        } else {
            return nil
        }
    }
}

extension Date {
    func occursOnSameDate(as date: Date) -> Bool {
        let paramDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let selfDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)

        return paramDateComponents.year == selfDateComponents.year &&
        paramDateComponents.month == selfDateComponents.month &&
        paramDateComponents.day == selfDateComponents.day
    }
}

extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view: UIView, animated: Bool, additionalOffset: CGFloat) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height - additionalOffset), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        print("SCROLLING TO BOTTOM: contentSize height: \(contentSize.height). Bounds height: \(bounds.size.height). ContentInset bottom: \(contentInset.bottom)")
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }

}

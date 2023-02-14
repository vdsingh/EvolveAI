//
//  EALabel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

/// Custom Label View
final class EALabel: UILabel, EAFormElementView {

    /// The height required for this Label
    var requiredHeight: CGFloat {
        self.font.pointSize * CGFloat(self.numberOfLines) + EAIncrement.one.rawValue
    }

    /// Normal initializer
    /// - Parameters:
    ///   - text: The text to display
    ///   - textStyle: The style of the text to display
    init(text: String, textStyle: EATextStyle, textColor: UIColor, numLines: Int) {
        super.init(frame: .zero)
        self.setUIProperties(text: text, textStyle: textStyle, textColor: textColor, numLines: numLines)
    }

    /// Sets the UI properties of this label View
    /// - Parameters:
    ///   - text: The text to display
    ///   - textStyle: The style of the text to display
    private func setUIProperties(
        text: String,
        textStyle: EATextStyle,
        textColor: UIColor,
        numLines: Int
    ) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.font = textStyle.font
        self.textColor = textColor
        self.numberOfLines = numLines
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

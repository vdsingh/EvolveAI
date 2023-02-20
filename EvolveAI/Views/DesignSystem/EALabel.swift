//
//  EALabel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

/// Custom Label View
final class EALabel: UILabel, EAUIElementView, Debuggable {
    let debug = false

    /// The height required for this Label
//    var requiredHeight: CGFloat? {
//        self.font.pointSize * CGFloat(self.numberOfLines) + EAIncrement.one.rawValue
//    }

//    let requiredHeight: CGFloat? = nil

    /// The callback function for when the label is clicked
    private var textWasClicked: (() -> Void)?

    /// Normal initializer
    /// - Parameters:
    ///   - text: The text to display
    ///   - textStyle: The style of the text to display
    init(text: String, textStyle: EATextStyle, textColor: UIColor, numLines: Int, textWasClicked: (() -> Void)?) {
        super.init(frame: .zero)
        self.setUIProperties(text: text, textStyle: textStyle, textColor: textColor, numLines: numLines)
        if let textWasClicked = textWasClicked {
            self.setClickHandler(handler: textWasClicked)
        }
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

        if debug {
            self.backgroundColor = .gray
        }
    }

    /// Calls the click handler when label is clicked
    @objc private func textWasClickedTarget() {
        if let textWasClicked = self.textWasClicked {
            textWasClicked()
        }
    }

    /// Sets a click handler for when the label is clicked
    /// - Parameter handler: The function called when the label is clicked
    func setClickHandler(handler: @escaping () -> Void) {
        self.textWasClicked = handler
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.textWasClickedTarget))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension EALabel {
    func printDebug(_ message: String) {
        if self.debug {
            print("$Log: \(message)")
        }
    }
}

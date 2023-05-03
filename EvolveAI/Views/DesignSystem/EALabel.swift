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

    /// The callback function for when the label is clicked
    private var textWasClicked: (() -> Void)?

    /// Normal initializer
    /// - Parameters:
    ///   - text: The text to display
    ///   - textStyle: The style of the text to display
    ///   - textColor: The color of the text
    ///   - numLines: The number of lines that the label is
    ///   - textWasClicked: Callback for when the
    init(
        text: String = "",
        textStyle: EATextStyle = .heading1,
        textColor: UIColor = EAColor.label.uiColor,
        numLines: Int = 0,
        textWasClicked: (() -> Void)? = nil
    ) {
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
    ///   - textColor: The color of the text
    ///   - numLines: The number of lines of the label
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

        if self.debug {
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

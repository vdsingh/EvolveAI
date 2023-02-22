//
//  EATextView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit

/// Custom TextView for this application (for long responses)
final class EATextView: UITextView, EAUIElementView {

    /// Normal Initializer
    init(borderColor: UIColor) {
        super.init(frame: .zero, textContainer: .none)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = EAIncrement.one.rawValue
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.cgColor

        self.backgroundColor = EAColor.background.uiColor
        self.textColor = EAColor.label.uiColor

        self.setConstraints()
    }

    /// Sets the border color of the TextView
    /// - Parameter color: The color to set the border to
    public func setBorderColor(color: UIColor) {
        self.layer.borderColor = color.cgColor
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

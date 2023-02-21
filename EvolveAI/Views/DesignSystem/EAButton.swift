//
//  EAButton.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit

/// Custom Button for this application
class EAButton: UIButton, EAUIElementViewStaticHeight {

    /// This button can be a FormElement and it must have a required height
    var requiredHeight = EAIncrement.five.rawValue

    /// The callback for when the button has been clicked
    private var buttonPressedCallback: (EAButton) -> Void

    /// Normal Initializer
    /// - Parameter text: The text for the button
    init(text: String, enabledOnStart: Bool, buttonPressedCallback: @escaping (EAButton) -> Void) {
        self.buttonPressedCallback = buttonPressedCallback
        super.init(frame: .zero)
        self.setUIProperties(text: text)
        self.setEnabled(enabled: enabledOnStart)
        self.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
    }

    @objc private func pressed() {
        self.buttonPressedCallback(self)
    }

    // MARK: - Private Functions

    /// Sets the UI properties of the Button
    /// - Parameter text: The text for the button
    private func setUIProperties(text: String) {
        self.setTitle(text, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = EAIncrement.one.rawValue
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: self.requiredHeight)
        ])
    }

    // MARK: - Public Functions

    /// Enables or disables the button
    /// - Parameter enabled: whether the button should be enabled
    public func setEnabled(enabled: Bool) {
        self.isEnabled = enabled
        self.backgroundColor = enabled ? .orange : .systemGray
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

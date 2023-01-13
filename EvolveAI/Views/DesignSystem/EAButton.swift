//
//  EAButton.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit

/// This delegate is used for when an EAButton was pressed.
protocol EAButtonDelegate {
    
    /// Function that gets called when the button is pressed
    /// - Parameter button: The button that was pressed
    func buttonWasPressed(_ button: EAButton)
}

/// Custom Button for this application
class EAButton: UIButton, EAFormElementView {
    
    /// This button can be a FormElement and it must have a required height
    var requiredHeight = EAIncrement.five.rawValue
    
    /// The delegate decides what to do when the button has been clicked
    var delegate: EAButtonDelegate?
    
    /// Normal Initializer
    /// - Parameter text: The text for the button
    init(text: String, enabledOnStart: Bool) {
        super.init(frame: .zero)
        self.setUIProperties(text: text)
        self.setEnabled(enabled: enabledOnStart)
        self.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
    }
    
    @objc private func pressed() {
        delegate?.buttonWasPressed(self)
    }
    
    // MARK: - Private Functions
    
    /// Sets the UI properties of the Button
    /// - Parameter text: The text for the button
    private func setUIProperties(text: String) {
        self.setTitle(text, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = EAIncrement.one.rawValue
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

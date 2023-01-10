//
//  EAButton.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit

protocol EAButtonDelegate {
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
    
    /// Sets the UI properties of the Button
    /// - Parameter text: The text for the button
    private func setUIProperties(text: String) {
        self.setTitle(text, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = EAIncrement.one.rawValue
    }
    
    public func setEnabled(enabled: Bool) {
        self.isEnabled = enabled
        self.backgroundColor = enabled ? .orange : .systemGray
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

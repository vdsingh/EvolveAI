//
//  EATextField.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit

protocol EATextFieldDelegate {
    func textFieldWasEdited(_ textField: EATextField)
}

/// Custom TextField for this application
class EATextField: UITextField {
    var editedDelegate: EATextFieldDelegate?
    
    /// Normal initializer
    init(editedDelegate: EATextFieldDelegate?) {
        self.editedDelegate = editedDelegate

        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = EAIncrement.one.rawValue
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.label.cgColor
        
        self.addTarget(self, action: #selector(textFieldWasEdited), for: .editingChanged)
    }
    
    @objc private func textFieldWasEdited() {
        editedDelegate?.textFieldWasEdited(self)
    }
    
    /// Sets the border color of the TextField
    /// - Parameter color: The color to set the border to
    public func setBorderColor(color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Sets the padding for the TextField (adding a small space in the beginning)
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

//
//  EATextField.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit

/// This protocol is used to specify what happens when a textField is edited
protocol EATextFieldDelegate {
    
    /// Function that is called when an EATextField has been edited
    /// - Parameter textField: The EATextField that was edited.
    func textFieldWasEdited(_ textField: EATextField)
}

/// Custom TextField for this application
class EATextField: UITextField {
    
    /// Delegate to use when this TextField has been edited
    var editedDelegate: EATextFieldDelegate?
    
    /// Normal initializer
    init(editedDelegate: EATextFieldDelegate?, borderColor: UIColor) {
        self.editedDelegate = editedDelegate
        super.init(frame: .zero)
        self.setUIProperties(borderColor: borderColor)
        self.addTarget(self, action: #selector(textFieldWasEdited), for: .editingChanged)
    }
    
    /// Sets the UI properties for this object
    private func setUIProperties(borderColor: UIColor) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = EAIncrement.one.rawValue
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.cgColor
    }
    
    /// Action for when this TextField was edited. Uses the delegate to call textFieldWasEdited
    @objc private func textFieldWasEdited() {
        self.editedDelegate?.textFieldWasEdited(self)
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

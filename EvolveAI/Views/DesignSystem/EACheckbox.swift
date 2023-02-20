//
//  EACheckbox.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/20/23.
//

import Foundation
import UIKit

/// Checkbox component
final class EACheckbox: UIButton, EAUIElementViewStaticHeight, Debuggable {
    let debug = true

    /// Size of the checkbox (width = height)
    var requiredHeight: CGFloat

    /// Optional handler for when this checkbox was toggled
    private var checkboxWasToggled: ((Bool) -> Void)?

    // TODO: Docstring
    private var color: UIColor = .label

    /// Normal initializer
    /// - Parameter size: Size of checkbox (defaults to EAIncrement.two)
    init(size: CGFloat = EAIncrement.two.rawValue, color: UIColor = .label) {
        self.requiredHeight = size
        self.color = color
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(self.checkboxClicked), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviewsAndEstablishConstraints()
        self.setUIProperties()
    }

    /// Adds the subviews and establishes constraints
    private func addSubviewsAndEstablishConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: self.requiredHeight),
            self.heightAnchor.constraint(equalToConstant: self.requiredHeight)
        ])
    }

    /// Sets the UI Properties for this view
    private func setUIProperties() {
        self.layer.cornerRadius = self.requiredHeight / 4
        self.layer.borderColor = self.color.cgColor
        self.layer.borderWidth = 1
    }

    /// Function called when a checkbox is clicked
    @objc private func checkboxClicked() {
        printDebug("Checkbox was clicked")
        self.setActive(active: !self.isSelected)
        if let handler = self.checkboxWasToggled {
            handler(self.isSelected)
        } else {
            print("$Error: checkbox handler was not specified.")
        }
    }

    // MARK: - Public

    // TODO: Docstring
    func setColor(_ color: UIColor) {
        self.color = color
        self.setUIProperties()
        self.setActive(active: self.isSelected)
    }

    /// Sets the handler for when this checkbox is toggled
    /// - Parameter checkboxWasToggled: The handler for when this checkbox is toggled
    public func setCheckboxHandler(checkboxWasToggled: @escaping (Bool) -> Void) {
        self.checkboxWasToggled = checkboxWasToggled
    }

    /// Checks or unchecks this checkbox
    /// - Parameter active: Whether the checkbox is checked or not
    public func setActive(active: Bool) {
        self.isSelected = active
        self.backgroundColor = self.isSelected ? self.color : .clear
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension EACheckbox {
    func printDebug(_ message: String) {
        if self.debug {
            print("$Log: \(message)")
        }
    }
}

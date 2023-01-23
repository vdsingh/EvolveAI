//
//  EACheckbox.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/20/23.
//

import Foundation
import UIKit

/// Checkbox component
final class EACheckbox: UIButton {

    /// Size of the checkbox (width = height)
    private var dimension: CGFloat

    /// Optional handler for when this checkbox was toggled
    private var checkboxWasToggled: ((Bool) -> Void)?

    /// Normal initializer
    /// - Parameter size: Size of checkbox (defaults to EAIncrement.two)
    init(size: CGFloat = EAIncrement.two.rawValue) {
        self.dimension = size
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(self.checkboxClicked), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviewsAndEstablishConstraints()
        self.setUIProperties()
    }

    /// Adds the subviews and establishes constraints
    private func addSubviewsAndEstablishConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: dimension),
            self.heightAnchor.constraint(equalToConstant: dimension)
        ])
    }

    /// Sets the UI Properties for this view
    private func setUIProperties() {
        self.layer.cornerRadius = dimension / 4
        self.layer.borderColor = UIColor.label.cgColor
        self.layer.borderWidth = 1
    }

    /// Function called when a checkbox is clicked
    @objc private func checkboxClicked() {
        self.isSelected = !self.isSelected
        self.backgroundColor = self.isSelected ? .green : .clear
        if let handler = self.checkboxWasToggled {
            handler(self.isSelected)
        }
    }

    // MARK: - Public

    /// Sets the handler for when this checkbox is toggled
    /// - Parameter checkboxWasToggled: The handler for when this checkbox is toggled
    public func setCheckboxHandler(checkboxWasToggled: @escaping (Bool) -> Void) {
        self.checkboxWasToggled = checkboxWasToggled
    }

    /// Checks or unchecks this checkbox
    /// - Parameter active: Whether the checkbox is checked or not
    public func setActive(active: Bool) {
        self.isSelected = active
        self.backgroundColor = self.isSelected ? .green : .clear
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

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
            self.heightAnchor.constraint(equalToConstant: dimension),
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
        if self.isSelected {
            self.backgroundColor = .green
        } else {
            self.backgroundColor = .red
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

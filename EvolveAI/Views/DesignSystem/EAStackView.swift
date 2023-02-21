//
//  EAStackView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

/// Custom StackView element
final class EAStackView: UIStackView, EAUIElementView {

    /// Normal initializer
    /// - Parameters:
    ///   - axis: The axis for this StackView
    ///   - subViews: The views contained within this StackView
    init(axis: NSLayoutConstraint.Axis, subViews: [EAUIElementView]) {
        super.init(frame: .zero)
        self.setUIProperties(axis: axis)
        self.addSubviews(subViews: subViews)
    }

    // MARK: - Private Functions

    /// Adds a Subview to the StackView
    /// - Parameter subview: The EAUIElementView to add
    private func addSubview(_ subview: EAUIElementView) {
        self.addArrangedSubview(subview)
    }

    /// Adds sub views to this StackView
    /// - Parameter subViews: The sub views to add to this StackView
    private func addSubviews(subViews: [EAUIElementView]) {
        for subView in subViews {
            self.addArrangedSubview(subView)
        }
    }

    /// Sets the UI properties for this StackView
    /// - Parameter axis: The axis for this StackView
    private func setUIProperties(axis: NSLayoutConstraint.Axis) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis

    }

    // MARK: - Public Functions

    /// Adds EAUIElements to the StackView
    /// - Parameter elements: The EAUIElements to add
    func addElements(_ elements: [EAUIElement]) {
        for element in elements {
            let view = element.createView()
            self.addSubview(view)
        }
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

//
//  EAStackView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

/// Custom StackView element
class EAStackView: UIStackView, EAUIElementView {

    /// Normal initializer
    /// - Parameters:
    ///   - axis: The axis for this StackView
    ///   - subViews: The views contained within this StackView
    ///   - alignment: The alignment for this StackView
    ///   - distribution: The distribution for this StackView
    ///   - spacing: The space between elements in this StackView
    init(
        axis: NSLayoutConstraint.Axis = .vertical,
        alignment: Alignment = .fill,
        distribution: Distribution = .fill,
        spacing: EAIncrement = .two,
        subViews: [EAUIElementView] = []
    ) {
        super.init(frame: .zero)
        self.setUIProperties(axis: axis, alignment: alignment, distribution: distribution, spacing: spacing)
        self.addSubviews(subViews)
    }

    /// Normal initializer
    /// - Parameters:
    ///   - axis: The axis for this StackView
    ///   - elements: The elements to be constructed contained within this StackView
    ///   - alignment: The alignment for this StackView
    ///   - distribution: The distribution for this StackView
    ///   - spacing: The space between elements in this StackView
    init(
        axis: NSLayoutConstraint.Axis = .vertical,
        alignment: Alignment = .fill,
        distribution: Distribution = .fill,
        spacing: EAIncrement = .two,
        elements: [EAUIElement] = []
    ) {
        super.init(frame: .zero)
        self.setUIProperties(axis: axis, alignment: alignment, distribution: distribution, spacing: spacing)
        self.addElements(elements)
    }

    // MARK: - Private Functions

    /// Sets the UI properties for this StackView
    /// - Parameter axis: The axis for this StackView
    /// - Parameter alignment: The alignment for this StackView
    /// - Parameter distribution: The distribution for this StackView
    /// - Parameter spacing: The space between elements in this StackView
    private func setUIProperties(
        axis: NSLayoutConstraint.Axis,
        alignment: Alignment,
        distribution: Distribution,
        spacing: EAIncrement) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing.rawValue
    }

    // MARK: - Public Functions

    /// Adds EAUIElements to the StackView
    /// - Parameter elements: The EAUIElements to add
    func addElements(_ elements: [EAUIElement]) {
        for element in elements {
            self.addElement(element)
        }
    }

    /// Adds a EAUIElement to this EAStackView
    /// - Parameter element: The EAUIElement to add
    func addElement(_ element: EAUIElement) {
        self.addSubview(element.createView())
    }

    /// Adds a Subview to the StackView
    /// - Parameter subview: The EAUIElementView to add
    func addSubview(_ subview: EAUIElementView) {
        self.addArrangedSubview(subview)
    }

    /// Adds sub views to this StackView
    /// - Parameter subViews: The sub views to add to this StackView
    func addSubviews(_ subViews: [EAUIElementView]) {
        for subView in subViews {
            self.addArrangedSubview(subView)
        }
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

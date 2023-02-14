//
//  EAStackView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

/// Custom StackView element
final class EAStackView: UIStackView, EAFormElementView {

    /// The height required for this UI element
    var requiredHeight: CGFloat

    /// Normal initializer
    /// - Parameters:
    ///   - axis: The axis for this StackView
    ///   - subViews: The views contained within this StackView
    init(axis: NSLayoutConstraint.Axis, subViews: [EAFormElementView]) {
        var calculatedHeight: CGFloat = 0
        if axis == .vertical {
            for subView in subViews {
                calculatedHeight += subView.requiredHeight
            }
        } else if axis == .horizontal {
            for subView in subViews {
                calculatedHeight = max(calculatedHeight, subView.requiredHeight)
            }
        }

        self.requiredHeight = calculatedHeight
        super.init(frame: .zero)
        self.setUIProperties(axis: axis)
        self.addSubviews(subViews: subViews)
    }

    /// Adds sub views to this StackView
    /// - Parameter subViews: The sub views to add to this StackView
    private func addSubviews(subViews: [EAFormElementView]) {
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

    required init(coder: NSCoder) {
        fatalError()
    }
}
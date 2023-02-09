//
//  EAStackView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

final class EAStackView: UIStackView, EAFormElementView {
    var requiredHeight: CGFloat

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

    private func addSubviews(subViews: [EAFormElementView]) {
        for subView in subViews {
            self.addArrangedSubview(subView)
        }
    }

    private func setUIProperties(axis: NSLayoutConstraint.Axis) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis

    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

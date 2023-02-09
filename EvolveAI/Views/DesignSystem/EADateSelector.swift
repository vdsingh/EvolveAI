//
//  EADateSelector.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

// TODO: Docstring
final class EADateSelector: UIDatePicker, EAFormElementView {
    private let dateWasSelectedCallback: (Date) -> Void
    var requiredHeight: CGFloat {
        return 50
    }

    init(style: UIDatePickerStyle, dateWasSelectedCallback: @escaping (Date) -> Void) {
        self.dateWasSelectedCallback = dateWasSelectedCallback
        super.init(frame: .zero)
        self.setUIProperties(style: style)

    }

    private func setUIProperties(style: UIDatePickerStyle) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.preferredDatePickerStyle = style
        self.contentHorizontalAlignment = .leading
        self.backgroundColor = .green
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

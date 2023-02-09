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

    init(style: UIDatePickerStyle, mode: Mode, dateWasSelectedCallback: @escaping (Date) -> Void) {
        self.dateWasSelectedCallback = dateWasSelectedCallback
        super.init(frame: .zero)
        self.setUIProperties(style: style, mode: mode)
        self.addTarget(self, action: #selector(dateWasChanged), for: .valueChanged)
    }

    private func setUIProperties(style: UIDatePickerStyle, mode: Mode) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.preferredDatePickerStyle = style
        self.datePickerMode = .date
        self.setDate(Date(), animated: true)
        self.contentHorizontalAlignment = .leading
    }
    
    @objc private func dateWasChanged() {
        self.dateWasSelectedCallback(self.date)
//        self.
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

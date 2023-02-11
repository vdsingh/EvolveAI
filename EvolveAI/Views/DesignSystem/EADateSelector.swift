//
//  EADateSelector.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

/// Custom Date Selector
final class EADateSelector: UIDatePicker, EAFormElementView {
    
    /// Callback for when a date is selected through this DatePicker
    private let dateWasSelectedCallback: (Date) -> Void
    
    /// The height required for this UI element
    var requiredHeight: CGFloat {
        return 50
    }
    
    /// Normal Initializer
    /// - Parameters:
    ///   - style: The style for this DateSelector
    ///   - mode: The mode for this DateSelector
    ///   - dateWasSelectedCallback: Callback function for when a date is selected
    init(style: UIDatePickerStyle, mode: Mode, dateWasSelectedCallback: @escaping (Date) -> Void) {
        self.dateWasSelectedCallback = dateWasSelectedCallback
        super.init(frame: .zero)
        self.setUIProperties(style: style, mode: mode)
        self.addTarget(self, action: #selector(dateWasChanged), for: .valueChanged)
    }
    
    /// Sets the UI properties for this DateSelector
    /// - Parameters:
    ///   - style: The style of the DatePicker
    ///   - mode: The mode of the DatePicker
    private func setUIProperties(style: UIDatePickerStyle, mode: Mode) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.preferredDatePickerStyle = style
        self.datePickerMode = .date
        self.setDate(Date(), animated: true)
        self.contentHorizontalAlignment = .leading
    }

    /// Target for when DatePicker date was changed
    @objc private func dateWasChanged() {
        self.dateWasSelectedCallback(self.date)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

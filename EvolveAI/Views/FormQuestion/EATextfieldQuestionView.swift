//
//  EATextfieldQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

/// View for basic TextField Questions
class EATextFieldQuestionView: UIStackView, EAUIElementViewStaticHeight {

    /// The required height for this view
    var requiredHeight: CGFloat = 90

    /// callback to use when the textfields are edited
    private var editedCallback: (EATextField) -> Void

    /// Label that displays the question
    private let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = .systemFont(ofSize: EAIncrement.two.rawValue, weight: .medium)
        return questionLabel
    }()

    /// TextField where user enters response
    private lazy var textField: EATextField = {
        let textField = EATextField(textWasEditedCallback: self.editedCallback, borderColor: .systemGray)
        return textField
    }()

    /// ViewModel initializer
    /// - Parameter viewModel: The ViewModel used to set the data of the View
    init(viewModel: EATextFieldQuestionViewModel) {
        self.editedCallback = viewModel.editedCallback
        super.init(frame: .zero)
        self.setUIProperties(viewModel: viewModel)
        self.addSubviewsAndEstablishConstraints()
    }

    /// Sets the UI properties for this View
    /// - Parameter viewModel: The ViewModel contains the information to assign for the properties
    private func setUIProperties(viewModel: EATextFieldQuestionViewModel) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.distribution = .fill
        self.alignment = .fill
        self.axis = .vertical
        self.spacing = EAIncrement.one.rawValue
        self.questionLabel.text = viewModel.question
        self.textField.keyboardType = viewModel.keyboardType
    }

    /// Add the subviews to the view and establish constraints
    private func addSubviewsAndEstablishConstraints() {
        self.addArrangedSubview(questionLabel)
        self.addArrangedSubview(textField)

        NSLayoutConstraint.activate([
            questionLabel.heightAnchor.constraint(equalToConstant: EAIncrement.two.rawValue)
        ])
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

//
//  EATextfieldQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

/// View for basic long text response Questions
final class EATextViewQuestionView: EAStackView {

    /// Label that displays the question
    let questionLabel: EALabel = {
        let questionLabel = EALabel(
            text: "",
            textStyle: .heading1,
            textColor: .label,
            numLines: 0,
            textWasClicked: nil
        )
        questionLabel.font = .systemFont(ofSize: EAIncrement.two.rawValue, weight: .medium)
        return questionLabel
    }()

    /// TextView where user enters response
    let textView: EATextView = {
        let textView = EATextView(borderColor: .secondaryLabel)
        return textView
    }()

    /// ViewModel initializer
    /// - Parameter viewModel: The ViewModel used to set the data of the View
    init(viewModel: EATextViewQuestionViewModel) {
        super.init(
            axis: .vertical,
            subViews: [
                questionLabel,
                textView
            ]
        )
        self.setUIProperties(viewModel: viewModel)
    }

    /// Sets the UI properties for this View
    /// - Parameter viewModel: The ViewModel contains the information to assign for the properties
    private func setUIProperties(viewModel: EATextViewQuestionViewModel) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.distribution = .fill
        self.alignment = .fill
        self.axis = .vertical
        self.spacing = EAIncrement.one.rawValue

        self.questionLabel.text = viewModel.question
        self.questionLabel.textColor = viewModel.labelColor
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

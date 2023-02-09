//
//  EAFormQuestionResponse.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
import UIKit

/// Used to create user interactable form elements
enum EAFormElement {
    // MARK: - Input Elements

    /// Used to create a basic question and response question.
    case textFieldQuestion(
        question: String,
        textfieldPlaceholder: String,
        keyboardType: UIKeyboardType,
        textFieldWasEdited: (_ textField: EATextField) -> Void
    )

    /// Used to create a basic question and long repsonse question
    case textViewQuestion(
        question: String,
        textViewWasEdited: (_ textView: UITextView) -> Void
    )

    /// Used to create a Goal creation question.
    case goalCreationQuestion(
        actionText: String,
        goalPlaceholder: String,
        connectorText: String,
        goalTextWasEdited: (_ textField: EATextField) -> Void,
        numDaysPlaceholder: String,
        numDaysTextWasEdited: (_ textField: EATextField) -> Void,
        numDaysLabel: String
    )

    // TODO: DOcstring

    case colorSelector(
        colors: [UIColor],
        colorWasSelected: (UIColor) -> Void
    )

    case dateSelector(
        style: UIDatePickerStyle,
        dateWasSelected: (Date) -> Void
    )

    /// Used to create a button
    case button(
        buttonText: String,
        enabledOnStart: Bool,
        viewSetter: (EAButton) -> Void,
        buttonPressed: (EAButton) -> Void
    )

    // MARK: - Static Elements
    case label(
        text: String
    )

    // MARK: - Containers

    // TODO: DOcstring
    case stack(
        axis: NSLayoutConstraint.Axis,
        elements: [EAFormElement]
    )

    // MARK: - Other Elements

    /// Used to create a separator
    case separator

    /// Transforms the response object to a UIView and returns it
    /// - Returns: a UIView which is the response object
    func createView() -> EAFormElementView {
        switch self {
        case .textFieldQuestion(let question, let placeholder, let keyboardType, let editedCallback):
            let viewModel = EATextFieldQuestionViewModel(
                question: question,
                responsePlaceholder: placeholder,
                editedCallback: editedCallback,
                keyboardType: keyboardType
            )
            let view = EATextFieldQuestionView(viewModel: viewModel)
            return view

        case .textViewQuestion(let question, _):
            let viewModel = EATextViewQuestionViewModel(question: question)
            let view = EATextViewQuestionView(viewModel: viewModel)
            return view
        case .goalCreationQuestion(
            let actionText,
            let goalPlaceholder,
            let connectorText,
            let goalTextWasEdited,
            let numDaysPlaceholder,
            let numDaysTextWasEdited,
            let numDaysLabel
        ):
            let viewModel = EACreateGoalQuestionViewModel(
                actionText: actionText,
                goalPlaceholderText: goalPlaceholder,
                goalEditedCallback: goalTextWasEdited,
                connectorText: connectorText,
                numDaysPlaceholderText: numDaysPlaceholder,
                numDaysEditedCallback: numDaysTextWasEdited,
                numDaysUnitLabel: numDaysLabel
            )
            let view = EACreateGoalQuestionView(viewModel: viewModel)
            return view

        case .colorSelector(let colors, let colorWasSelected):
            return EAColorSelector(colors: colors, colorWasSelectedCallback: colorWasSelected)

        case .dateSelector(style: let style, dateWasSelected: let dateWasSelected):
            return EADateSelector(style: style, dateWasSelectedCallback: dateWasSelected)

        case .button(let buttonText, let enabledOnStart, let viewSetter, let buttonPressed):
            let view = EAButton(text: buttonText, enabledOnStart: enabledOnStart, buttonPressedCallback: buttonPressed)
            viewSetter(view)
            return view

        case .label(let text):
            let label = EALabel(text: text)
            return label

        case .stack(let axis, let elements):
            let subViews = elements.map { $0.createView() }
            let stack = EAStackView(axis: axis, subViews: subViews)
            return stack

        case .separator:
            return EASeparator()
        }
    }
}

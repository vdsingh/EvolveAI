//
//  EAFormQuestionResponse.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
import UIKit

/// Used to create user interactable form elements
enum EAUIElement {
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

    /// Used to create a color selector
    case colorSelector(
        colors: [UIColor],
        colorWasSelected: (UIColor) -> Void
    )

    /// Used to create a date selector
    case dateSelector(
        style: UIDatePickerStyle,
        mode: UIDatePicker.Mode,
        dateWasSelected: (Date) -> Void
    )

    /// Used to create a button
    case button(
        buttonText: String,
        enabledOnStart: Bool,
        viewSetter: (EAButton) -> Void,
        buttonPressed: (EAButton) -> Void
    )

    case task(
        viewModel: EAGoalTaskViewModel?
    )

    // MARK: - Static Elements

    /// Used to create a basic label
    case label(
        text: String,
        textStyle: EATextStyle = .body,
        textColor: UIColor = .label,
        numLines: Int = 0,
        textWasClicked: (() -> Void)? = nil
    )
    
    case tag(
        text: String
    )

    // MARK: - Containers

    /// Used to create a StackView container
    case stack(
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution = .fill,
        spacing: EAIncrement,
        elements: [EAUIElement]
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

        case .dateSelector(let style, let mode, let dateWasSelected):
            return EADateSelector(style: style, mode: mode, dateWasSelectedCallback: dateWasSelected)

        case .button(let buttonText, let enabledOnStart, let viewSetter, let buttonPressed):
            let view = EAButton(text: buttonText, enabledOnStart: enabledOnStart, buttonPressedCallback: buttonPressed)
            viewSetter(view)
            return view

        case .task(let viewModel):
            if let viewModel = viewModel {
                return EAGoalTaskView(viewModel: viewModel)
            } else {
                print("$Log: Task has a nil ViewModel. Returning an EmptyView")
                return EAEmptyView()
            }

        case .label(let text, let textStyle, let textColor, let numLines, let textWasClicked):
            let label = EALabel(text: text, textStyle: textStyle, textColor: textColor, numLines: numLines, textWasClicked: textWasClicked)
            return label
            
        case .tag(let text):
            let tag = EATagButton(tag: text)
            return tag

        case .stack(let axis, let distribution, let spacing, let elements):
            let subViews = elements.map { $0.createView() }
            let stack = EAStackView(axis: axis, subViews: subViews)
            stack.spacing = spacing.rawValue
            stack.distribution = distribution
            return stack

        case .separator:
            return EASeparator()
        }
    }
}

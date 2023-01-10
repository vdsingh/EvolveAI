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
    // MARK: - Question Elements
    
    /// Used to create a basic question and response question.
    case textFieldQuestion(
        question: String,
        textfieldPlaceholder: String,
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
    
    // MARK: - Other Elements
    
    /// Used to create a button
    case button(
        buttonText: String,
        enabledOnStart: Bool,
        viewSetter: (EAButton) -> Void,
        buttonPressed: () -> Void
    )
    
    /// Used to create a separator
    case separator
    
    /// Transforms the response object to a UIView and returns it
    /// - Returns: a UIView which is the response object
    func createView() -> EAFormElementView {
        switch self {
        case .textFieldQuestion(let question, let placeholder, _):
            let viewModel = EATextFieldQuestionViewModel(
                question: question,
                responsePlaceholder: placeholder
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
            let connectorText, _,
            let numDaysPlaceholder, _,
            let numDaysLabel
        ):
            let viewModel = EACreateGoalQuestionViewModel(
                actionText: actionText,
                goalPlaceholderText: goalPlaceholder,
                connectorText: connectorText,
                numDaysPlaceholderText: numDaysPlaceholder,
                numDaysUnitLabel: numDaysLabel
            )
            let view = EACreateGoalQuestionView(viewModel: viewModel)
            return view
        case .button(let buttonText, let enabledOnStart, let viewSetter, _):
            let view = EAButton(text: buttonText, enabledOnStart: enabledOnStart)
            viewSetter(view)
            return view
            
        case .separator:
            let view = EASeparator()
            return view
        }
    }
}

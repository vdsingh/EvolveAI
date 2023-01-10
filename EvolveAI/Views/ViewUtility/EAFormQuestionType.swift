//
//  EAFormQuestionResponse.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
import UIKit

/// Used to create user interactable response objects for questions on forms
enum EAFormQuestionType {
    /// Used to create a TextField as a question response for forms
    case textfield(question: String,
                   textfieldPlaceholder: String,
                   textFieldWasEdited: (_ text: String) -> Void)
    
    case goalCreation(actionText: String,
                      goalPlaceholder: String,
                      connectorText: String,
                      goalTextWasEdited: (_ text: String) -> Void,
                      numDaysPlaceholder: String,
                      numDaysTextWasEdited: (_ text: String) -> Void,
                      numDaysLabel: String)
    
    /// Transforms the response object to a UIView and returns it
    /// - Returns: a UIView which is the response object
    func getView() -> EAFormQuestionView {
        switch self {
        case .textfield(let question, let placeholder, _):
            let viewModel = EATextfieldQuestionViewModel(
                question: question,
                responsePlaceholder: placeholder
            )
            let view = EATextfieldQuestionView(viewModel: viewModel)
            return view
        case .goalCreation(let actionText, let goalPlaceholder, let connectorText, _, let numDaysPlaceholder, _, let numDaysLabel):
            let viewModel = EACreateGoalQuestionViewModel(
                actionText: actionText,
                goalPlaceholderText: goalPlaceholder,
                connectorText: connectorText,
                numDaysPlaceholderText: numDaysPlaceholder,
                numDaysUnitLabel: numDaysLabel
            )
            let view = EACreateGoalQuestionView(viewModel: viewModel)
            return view
        }
    }
}

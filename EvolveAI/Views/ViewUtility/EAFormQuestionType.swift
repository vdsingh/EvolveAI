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
    
//    case goalCreation(goalPlaceholder: String,
//                      goalTextWasEdited: (_ text: String) -> Void,
//                      numDaysPlaceholder: String,
//                      numDaysTextWasEdited: (_ text: String) -> Void)
    
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
//        case .goalCreation(let goalPlaceholder, _, let numDaysPlaceholder, _):
//            break
        }
    }
}

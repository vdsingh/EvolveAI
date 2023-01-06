//
//  EAFormQuestionResponse.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
import UIKit
/// Used to create user interactable response objects for questions on forms
enum EAFormQuestionResponse {
    /// Used to create a TextField as a question response for forms
    case textfield(placeholder: String, textFieldWasEdited: (_ text: String) -> Void)
    
    /// Transforms the response object to a UIView and returns it
    /// - Returns: a UIView which is the response object
    func getUIObject() -> UIView {
        switch self {
        case .textfield(let placeholder, _):
            let textfield = UITextField()
            textfield.backgroundColor = .secondarySystemBackground
            textfield.layer.cornerRadius = 5
            textfield.placeholder = placeholder
            textfield.translatesAutoresizingMaskIntoConstraints = false
            return textfield
        }
    }
}

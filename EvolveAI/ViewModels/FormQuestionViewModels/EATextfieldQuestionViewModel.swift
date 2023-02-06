//
//  EAFormQuestionViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
import UIKit

/// A ViewModel for EAFormQuestions
struct EATextFieldQuestionViewModel {

    /// The question as a String
    let question: String

    /// The placeholder for the response textfield
    let responsePlaceholder: String

    /// Callback for when the TextField is edited
    let editedCallback: (EATextField) -> Void
    
    /// The Keyboard Type for this TextField Question
    let keyboardType: UIKeyboardType
}

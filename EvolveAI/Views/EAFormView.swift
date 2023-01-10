//
//  FormView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/5/23.
//

import Foundation
import UIKit

/// View for Forms
class EAFormView: UIView {
    
    /// The UIViews for the questions
    var questionViews: [UIView]
    
    /// A map for the callback functions for when text inputs have been edited
    private var delegateCallbackGraph: [UIView: ((_ text: String) -> Void)] = [:]
    
    /// A map for the callback functions for when buttons has been pressed
    private var buttonDelegateCallbackGraph: [UIView: (() -> Void)] = [:]

    /// ViewModel initializer
    /// - Parameter viewModels: The EAFormQuestionViewModels to instantiate the View
    init(formElements: [EAFormElement]) {
        self.questionViews = []
        
        super.init(frame: .zero)
        self.backgroundColor = .yellow

        self.addViewsAndEstablishConstraints(formElements: formElements)
    }
    
    /// Add the subviews to the view and establish constraints
    /// - Parameter formElements: The EAFormElements which specify the subviews to add
    private func addViewsAndEstablishConstraints(formElements: [EAFormElement]) {
        let stack = constructFormElementStackView(formElements: formElements)
        stack.spacing = EAIncrement.two.rawValue
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: EAIncrement.two.rawValue),
            stack.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -EAIncrement.two.rawValue),
            stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: EAIncrement.two.rawValue),
        ])
    }
    
    /// Constructs a UIStackView that contains all of the form element views
    /// - Parameter formElements: the EAFormElement which specify the subviews to add
    /// - Returns: a UIStackView that contains all of the Form Element views
    private func constructFormElementStackView(formElements: [EAFormElement]) -> UIStackView {
        let elementStack = UIStackView()
        elementStack.translatesAutoresizingMaskIntoConstraints = false
        elementStack.axis = .vertical
        
        for formElement in formElements {
            let view = formElement.getView()
            self.questionViews.append(view)
            elementStack.addArrangedSubview(view)
            
            view.heightAnchor.constraint(equalToConstant: view.requiredHeight).isActive = true
            
            self.mapDelegates(formElement: formElement, view: view)
        }
        
        return elementStack
    }
    
    /// Maps the delegate functions for questions that have responses so that a controller can specify a callback
    /// - Parameters:
    ///   - formElement: The EAFormElement representing the form element
    ///   - view: The EAFormElementView used to access the corresponding Views and set the delegates
    private func mapDelegates(formElement: EAFormElement, view: EAFormElementView) {
        switch formElement {
        case .textFieldQuestion(_, _, let textFieldWasEdited):
            guard let questionView = view as? EATextFieldQuestionView else {
                fatalError("$Error: expected EATextfieldQuestionView but got a different type.")
            }
            
            questionView.textField.delegate = self
            self.delegateCallbackGraph[questionView.textField] = textFieldWasEdited
        
        case .textViewQuestion(_, let textViewWasEdited):
            guard let questionView = view as? EATextViewQuestionView else {
                fatalError("$Error: expected EATextViewQuestionView but got a different type.")
            }
            
            questionView.textView.delegate = self
            self.delegateCallbackGraph[questionView.textView] = textViewWasEdited
            
        case .goalCreationQuestion(_,_,_, let goalEdited,_, let numDaysEdited, _):
            guard let questionView = view as? EACreateGoalQuestionView else {
                fatalError("$Error: expected EACreateGoalQuestionView but got a different type.")
            }
            
            questionView.goalTextField.delegate = self
            questionView.numDaysTextField.delegate = self
            self.delegateCallbackGraph[questionView.goalTextField] = goalEdited
            self.delegateCallbackGraph[questionView.numDaysTextField] = numDaysEdited
        case .button(_, let buttonPressed):
            guard let buttonView = view as? EAButton else {
                fatalError("$Error: expected EAButton but got a different type.")
            }
            
            buttonView.delegate = self
            self.buttonDelegateCallbackGraph[buttonView] = buttonPressed
        case .separator:
            break
        }
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

// MARK: - TextField Delegate
extension EAFormView: UITextFieldDelegate {
    /// Handles UITextFieldDidEndEditing for questions whose response is a textfield
    /// - Parameter textField: the textfield in question
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Find the callback function for the specified textfield
        guard let callback = delegateCallbackGraph[textField] else {
            return
        }
        
        // Call the callback with the TextField's text.
        callback(textField.text ?? "")
    }
}

// MARK: - TextView Delegate
extension EAFormView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        // Find the callback function for the specified textfield
        guard let callback = delegateCallbackGraph[textView] else {
            return
        }
        
        // Call the callback with the TextView's text.
        callback(textView.text ?? "")
    }
}

extension EAFormView: EAButtonDelegate {
    func buttonWasPressed(_ button: EAButton) {
        // Find the callback function for the specified textfield
        guard let callback = buttonDelegateCallbackGraph[button] else {
            return
        }
        
        // Call the callback with the textfield's text.
        callback()
    }
}

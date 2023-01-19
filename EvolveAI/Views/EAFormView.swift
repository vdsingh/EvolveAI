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
    
    /// A map for the callback functions for when TextFields have been edited
    private var textFieldDelegateCallbackGraph: [UIView: ((_ textField: EATextField ) -> Void)] = [:]
    
    /// A map for the callback functions for when TextViews have been edited
    private var textViewDelegateCallbackGraph: [UIView: ((_ textView: UITextView ) -> Void)] = [:]

    /// A map for the callback functions for when buttons has been pressed
    private var buttonDelegateCallbackGraph: [UIView: (() -> Void)] = [:]
    
    /// Boolean representing whether the form is loading or not
    private var isFormLoading: Bool
    
    /// A spinner to indicate when we are loading data
    private let spinner: EASpinner = {
        let spinner = EASpinner(subText: "AI is working...")
        return spinner
    }()
    
    // MARK: - Initiailizer
    
    /// ViewModel initializer
    /// - Parameter viewModels: The EAFormQuestionViewModels to instantiate the View
    init(formElements: [EAFormElement]) {
        self.questionViews = []
        self.isFormLoading = false
        
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground

        self.addViewsAndEstablishConstraints(formElements: formElements)
    }
    
    // MARK: - Private Functions
    
    /// Add the subviews to the view and establish constraints
    /// - Parameter formElements: The EAFormElements which specify the subviews to add
    private func addViewsAndEstablishConstraints(formElements: [EAFormElement]) {
        let stack = constructFormElementStackView(formElements: formElements)
        stack.spacing = EAIncrement.two.rawValue
        self.addSubview(stack)
        self.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: EAIncrement.two.rawValue),
            stack.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -EAIncrement.two.rawValue),
            stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: EAIncrement.two.rawValue),
            
            spinner.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: spinner.requiredHeight),
            spinner.widthAnchor.constraint(equalToConstant: spinner.requiredHeight),
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
            let view = formElement.createView()
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
            
            questionView.editedDelegate = self
            self.textFieldDelegateCallbackGraph[questionView.textField] = textFieldWasEdited
        
        case .textViewQuestion(_, let textViewWasEdited):
            guard let questionView = view as? EATextViewQuestionView else {
                fatalError("$Error: expected EATextViewQuestionView but got a different type.")
            }
            
            questionView.textView.delegate = self
            self.textViewDelegateCallbackGraph[questionView.textView] = textViewWasEdited
            
        case .goalCreationQuestion(_,_,_, let goalEdited,_, let numDaysEdited, _):
            guard let questionView = view as? EACreateGoalQuestionView else {
                fatalError("$Error: expected EACreateGoalQuestionView but got a different type.")
            }
            
            questionView.goalTextField.editedDelegate = self
            questionView.numDaysTextField.editedDelegate = self
            self.textFieldDelegateCallbackGraph[questionView.goalTextField] = goalEdited
            self.textFieldDelegateCallbackGraph[questionView.numDaysTextField] = numDaysEdited
        case .button(_, _, _, let buttonPressed):
            guard let buttonView = view as? EAButton else {
                fatalError("$Error: expected EAButton but got a different type.")
            }
            
            buttonView.delegate = self
            self.buttonDelegateCallbackGraph[buttonView] = buttonPressed
        case .separator:
            break
        }
    }
    
    // MARK: - Public Functions
    
    /// Toggle whether the form is loading or not (the spinners active status, user interaction)
    /// - Parameter isActive: Whether the page is loading or not
    public func setLoading(isLoading: Bool) {
        if isLoading {
            self.isUserInteractionEnabled = false
            self.isFormLoading = true
            self.spinner.startAnimating()
        } else {
            self.isUserInteractionEnabled = true
            self.isFormLoading = false
            self.spinner.stopAnimating()
        }
    }
    
    /// Getter for whether the form is loading or not
    /// - Returns: A boolean describing whether the form is loading or not
    public func isLoading() -> Bool {
        return self.isFormLoading
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

// MARK: - TextField Delegate
extension EAFormView: EATextFieldDelegate {
    func textFieldWasEdited(_ textField: EATextField) {
        // Find the callback function for the specified textfield
        guard let callback = textFieldDelegateCallbackGraph[textField] else {
            return
        }
        
        // Call the callback with the TextView's text.
        callback(textField)
    }
}

// MARK: - TextView Delegate
extension EAFormView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        // Find the callback function for the specified TextView
        guard let callback = textViewDelegateCallbackGraph[textView] else {
            return
        }
        
        // Call the callback with the TextView's text.
        callback(textView)
    }
}

// MARK: - Button Delegate
extension EAFormView: EAButtonDelegate {
    func buttonWasPressed(_ button: EAButton) {
        // Find the callback function for the specified Button
        guard let callback = buttonDelegateCallbackGraph[button] else {
            return
        }
        
        // Call the callback for the Button
        callback()
    }
}

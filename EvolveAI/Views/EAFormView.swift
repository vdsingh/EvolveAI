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
    
    /// The constants used in this View
    struct Constants {
        /// The padding for the questions stack
        static let padding: CGFloat = 20
        /// The spacing between questions
        static let spacing: CGFloat = 20
    }
    
    /// A map for the callback functions for when textfield has been edited
    private var textfieldCallbackGraph: [UITextField: ((_ text: String) -> Void)] = [:]
    
    /// ViewModel initializer
    /// - Parameter viewModels: The EAFormQuestionViewModels to instantiate the View
    init(questions: [EAFormQuestionType]) {
        self.questionViews = []
        
        super.init(frame: .zero)
        self.backgroundColor = .yellow

        self.addViewsAndEstablishConstraints(questions: questions)
    }
    
    /// Add the subviews to the view and establish constraints
    /// - Parameter questions: The ViewModels which specify the subviews to add
    private func addViewsAndEstablishConstraints(questions: [EAFormQuestionType]) {
        let stack = constructQuestionsStackView(questions: questions)
        stack.spacing = Constants.spacing
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: Constants.padding),
            stack.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -Constants.padding),
            stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
        ])
    }
    
    /// Constructs a UIStackView that contains all of the question views
    /// - Parameter questionViewModels: the viewModels that represent the forms questions
    /// - Returns: a UIStackView that contains all of the question views
    private func constructQuestionsStackView(questions: [EAFormQuestionType]) -> UIStackView {
        let questionStack = UIStackView()
        questionStack.translatesAutoresizingMaskIntoConstraints = false
        questionStack.axis = .vertical
        
        for question in questions {
            let view = question.getView()
            self.questionViews.append(view)
            questionStack.addArrangedSubview(view)
            
            view.heightAnchor.constraint(equalToConstant: view.requiredHeight).isActive = true
            
            switch question {
            case .textfield(_, _, let textFieldWasEdited):
                guard let questionView = view as? EATextfieldQuestionView else {
                    fatalError("$Error: expected UITextField but got a different type.")
                }
                questionView.textfield.delegate = self
                self.textfieldCallbackGraph[questionView.textfield] = textFieldWasEdited
            }
        }
        
        return questionStack
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

extension EAFormView: UITextFieldDelegate {
    /// Handles UITextFieldDidEndEditing for questions whose response is a textfield
    /// - Parameter textField: the textfield in question
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Find the callback function for the specified textfield
        guard let callback = textfieldCallbackGraph[textField] else {
            return
        }
        
        // Call the callback with the textfield's text.
        callback(textField.text ?? "")
    }
}

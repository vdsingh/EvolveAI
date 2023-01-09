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
    init(questionViewModels: [EAFormQuestionViewModel]) {
        self.questionViews = []
        
        super.init(frame: .zero)
        self.backgroundColor = .yellow

        self.addViewsAndEstablishConstraints(questionViewModels: questionViewModels)
    }
    
    /// Add the subviews to the view and establish constraints
    /// - Parameter questions: The ViewModels which specify the subviews to add
    private func addViewsAndEstablishConstraints(questionViewModels: [EAFormQuestionViewModel]) {
        let stack = constructQuestionsStackView(questionViewModels: questionViewModels)
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
    private func constructQuestionsStackView(questionViewModels: [EAFormQuestionViewModel]) -> UIStackView {
        let questionStack = UIStackView()
        questionStack.translatesAutoresizingMaskIntoConstraints = false
        questionStack.axis = .vertical
        
        for questionViewModel in questionViewModels {
            let view = EAFormQuestionView(viewModel: questionViewModel)
            view.translatesAutoresizingMaskIntoConstraints = false
            self.questionViews.append(view)
            questionStack.addArrangedSubview(view)
            
            switch questionViewModel.questionResponse {
            case .textfield(_, let textFieldWasEdited):
                guard let textfield = view.questionResponseView as? UITextField else {
                    fatalError("$Error: expected UITextField but got a different type.")
                }
                textfield.delegate = self
                self.textfieldCallbackGraph[textfield] = textFieldWasEdited
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

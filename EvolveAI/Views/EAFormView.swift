//
//  FormView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/5/23.
//

import Foundation
import UIKit
class EAFormView: UIView {
    
    var questions: [UIView]
    private let padding: CGFloat = 20
    private let spacing: CGFloat = 20
    
    private var textfieldCallbackGraph: [UITextField: ((_ text: String) -> Void)] = [:]
    
    init(questions: [EAFormQuestionViewModel]) {
        self.questions = []
        
        super.init(frame: .zero)
        self.backgroundColor = .yellow

        self.setupUI(questions: questions)
    }
    
    private func setupUI(questions: [EAFormQuestionViewModel]) {
        let stack = constructQuestionsStackView(questions: questions)
        stack.spacing = spacing
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: padding),
            stack.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -padding),
            stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
        ])
    }
    
    private func constructQuestionsStackView(questions: [EAFormQuestionViewModel]) -> UIStackView {
        let questionStack = UIStackView()
        questionStack.translatesAutoresizingMaskIntoConstraints = false
        questionStack.axis = .vertical
        
        
        for questionViewModel in questions {
            let view = EAFormQuestionView(viewModel: questionViewModel)
            view.translatesAutoresizingMaskIntoConstraints = false
            self.questions.append(view)
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let callback = textfieldCallbackGraph[textField] else {
            return
        }
        callback(textField.text ?? "")
    }
}

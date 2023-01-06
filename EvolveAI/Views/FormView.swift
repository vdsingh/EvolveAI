//
//  FormView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/5/23.
//

import Foundation
import UIKit
class FormView: UIView {
    
    var questions: [UIView]
    private let padding: CGFloat = 20
    private let spacing: CGFloat = 20
    
//    private var textfieldWasEdited: ((_ text: String) -> Void)?
    private var textfieldCallbackGraph: [UITextField: ((_ text: String) -> Void)] = [:]
    
    init(questions: [FormQuestionViewModel]) {
        self.questions = []
        
        super.init(frame: .zero)
        self.backgroundColor = .yellow

        self.setupUI(questions: questions)
        
        print("Form instantiated with \(questions)")

    }
    
    private func setupUI(questions: [FormQuestionViewModel]) {
        let stack = constructQuestionsStackView(questions: questions)
        stack.spacing = spacing
        addSubview(stack)
//        setQuestionStackConstraints(stackView: stack)
        
        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: padding),
            stack.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -padding),
            stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
//            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func constructQuestionsStackView(questions: [FormQuestionViewModel]) -> UIStackView {
        let questionStack = UIStackView()
        questionStack.translatesAutoresizingMaskIntoConstraints = false
        questionStack.axis = .vertical
        
        
        for questionViewModel in questions {
            let view = FormQuestionView(viewModel: questionViewModel)
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
//                self.textfieldWasEdited = textFieldWasEdited
            }
        }
        
        return questionStack
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

extension FormView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let callback = textfieldCallbackGraph[textField] else {
            return
        }
        callback(textField.text ?? "")
    }
}

//
//  FormQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/5/23.
//

import Foundation
import UIKit

struct FormQuestionViewModel {
    let question: String
    let questionResponse: UIQuestionResponse
}

class FormQuestionView: UIView {
    
    private let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        return questionLabel
    }()
    
    public let questionResponseView: UIView
    private let questionResponse: UIQuestionResponse
    
//    private let textfieldDelegate
    
    init(viewModel: FormQuestionViewModel) {
        
        
        self.questionLabel.text = viewModel.question
        self.questionResponse = viewModel.questionResponse
        self.questionResponseView = viewModel.questionResponse.getUIObject()
        
        super.init(frame: .zero)
        
        self.setupUI()
        
        print("Question instantiated with \(viewModel.question)")
    }
    
    private func setupUI() {
        self.addSubview(self.questionLabel)
        self.addSubview(self.questionResponseView)
        
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.questionLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.questionLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.questionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.questionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5, constant: 0),
            
            self.questionResponseView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.questionResponseView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.questionResponseView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor),
            self.questionResponseView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

enum UIQuestionResponse {
    case textfield(placeholder: String, textFieldWasEdited: (_ text: String) -> Void)
    
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

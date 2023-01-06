//
//  FormQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/5/23.
//

import Foundation
import UIKit

struct EAFormQuestionViewModel {
    let question: String
    let questionResponse: EAFormQuestionResponse
}

/// A view to represent form questions, which contain both the question label and a response object
class EAFormQuestionView: UIView {
    
    /// A label that shows the question text
    private let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        return questionLabel
    }()
    
    /// A UIView for the user inputted response to the question
    public let questionResponseView: UIView
    
    /// The specific question response object
    private let questionResponse: EAFormQuestionResponse
    
    /// ViewModel initializer
    /// - Parameter viewModel: the viewModel that is used to initialize this view
    init(viewModel: EAFormQuestionViewModel) {
        self.questionLabel.text = viewModel.question
        self.questionResponse = viewModel.questionResponse
        self.questionResponseView = viewModel.questionResponse.getUIObject()
        
        super.init(frame: .zero)
        
        self.setupUI()
    }
    
    
    /// Adds the required subviews and calls a function to establish contraints
    private func setupUI() {
        self.addSubview(self.questionLabel)
        self.addSubview(self.questionResponseView)
        
        self.setupConstraints()
    }
    
    /// Establishes constraints for all necessary subviews
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

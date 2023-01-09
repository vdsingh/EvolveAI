//
//  EATextfieldQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit
class EATextfieldQuestionView: UIStackView, EAFormQuestionView {
    var requiredHeight: CGFloat = 80
    
    let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = .systemFont(ofSize: Constants.bodyFontSize, weight: .medium)
        return questionLabel
    }()
    
    let textfield: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .secondarySystemBackground
        textfield.layer.cornerRadius = 10
        return textfield
    }()
    
    init(viewModel: EATextfieldQuestionViewModel) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillEqually
        alignment = .fill
        axis = .vertical
        backgroundColor = .green
        spacing = 5
        
        self.questionLabel.text = viewModel.question
        self.textfield.placeholder = viewModel.responsePlaceholder
        addSubviewsAndEstablishConstraints()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubviewsAndEstablishConstraints() {
        addArrangedSubview(questionLabel)
        addArrangedSubview(textfield)
        
        NSLayoutConstraint.activate([
            questionLabel.heightAnchor.constraint(equalToConstant: Constants.bodyFontSize),
            textfield.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

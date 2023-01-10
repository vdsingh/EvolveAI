//
//  EATextfieldQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit
/// View for basic TextField Questions
class EATextfieldQuestionView: UIStackView, EAFormQuestionView {
    /// The required height for this view
    var requiredHeight: CGFloat = 80
    
    /// Label that displays the question
    let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = .systemFont(ofSize: EAFontSize.bodyFontSize.rawValue, weight: .medium)
        return questionLabel
    }()
    
    /// TextField where user enters response
    let textfield: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .secondarySystemBackground
        textfield.layer.cornerRadius = 10
        return textfield
    }()
    
    /// ViewModel initializer
    /// - Parameter viewModel: The ViewModel used to set the data of the View
    init(viewModel: EATextfieldQuestionViewModel) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.distribution = .fillProportionally
        self.alignment = .fill
        self.axis = .vertical
        self.backgroundColor = .green
        self.spacing = 5
        
        self.questionLabel.text = viewModel.question
        self.textfield.placeholder = viewModel.responsePlaceholder
        self.addSubviewsAndEstablishConstraints()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Add the subviews to the view and establish constraints
    private func addSubviewsAndEstablishConstraints() {
        self.addArrangedSubview(questionLabel)
        self.addArrangedSubview(textfield)
        
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

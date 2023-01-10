//
//  EATextfieldQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

/// View for basic TextField Questions
class EATextFieldQuestionView: UIStackView, EAFormElementView {
    
    /// The required height for this view
    var requiredHeight: CGFloat = 90
    
    public var editedDelegate: EATextFieldDelegate?
    
    /// Label that displays the question
    let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = .systemFont(ofSize: EAFontSize.bodyFontSize.rawValue, weight: .medium)
        return questionLabel
    }()
    
    /// TextField where user enters response
    lazy var textField: EATextField = {
        let textField = EATextField(editedDelegate: self.editedDelegate)
        return textField
    }()
    
    /// ViewModel initializer
    /// - Parameter viewModel: The ViewModel used to set the data of the View
    init(viewModel: EATextFieldQuestionViewModel) {
        super.init(frame: .zero)
        self.setUIProperties(viewModel: viewModel)
        self.addSubviewsAndEstablishConstraints()
    }
    
    /// Sets the UI properties for this View
    /// - Parameter viewModel: The ViewModel contains the information to assign for the properties
    private func setUIProperties(viewModel: EATextFieldQuestionViewModel) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.distribution = .fill
        self.alignment = .fill
        self.axis = .vertical
        self.spacing = EAIncrement.one.rawValue
        
        self.questionLabel.text = viewModel.question
    }
    
    /// Add the subviews to the view and establish constraints
    private func addSubviewsAndEstablishConstraints() {
        self.addArrangedSubview(questionLabel)
        self.addArrangedSubview(textField)
        
        NSLayoutConstraint.activate([
            questionLabel.heightAnchor.constraint(equalToConstant: EAFontSize.bodyFontSize.rawValue)
        ])
    }
    
    required init(coder: NSCoder) {
        self.editedDelegate = nil
        super.init(coder: coder)
    }
}

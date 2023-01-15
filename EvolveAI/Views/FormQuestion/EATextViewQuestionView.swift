//
//  EATextfieldQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

/// View for basic long text response Questions
class EATextViewQuestionView: UIStackView, EAFormElementView {
    
    /// The required height for this view
    var requiredHeight: CGFloat = 150
    
    /// Label that displays the question
    let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = .systemFont(ofSize: EAIncrement.two.rawValue, weight: .medium)
        return questionLabel
    }()
    
    /// TextView where user enters response
    let textView: EATextView = {
        let textView = EATextView()
        return textView
    }()
    
    /// ViewModel initializer
    /// - Parameter viewModel: The ViewModel used to set the data of the View
    init(viewModel: EATextViewQuestionViewModel) {
        super.init(frame: .zero)
        self.setUIProperties(viewModel: viewModel)
        self.addSubviewsAndEstablishConstraints()
    }
    
    /// Sets the UI properties for this View
    /// - Parameter viewModel: The ViewModel contains the information to assign for the properties
    private func setUIProperties(viewModel: EATextViewQuestionViewModel) {
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
        self.addArrangedSubview(textView)
        
        NSLayoutConstraint.activate([
            questionLabel.heightAnchor.constraint(equalToConstant: EAIncrement.two.rawValue)
        ])
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

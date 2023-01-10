//
//  EACreateGoalQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit
class EACreateGoalQuestionView: UIStackView,  EAFormQuestionView {
    var requiredHeight: CGFloat = 190
    let actionTextLabel: UILabel = {
        let actionTextLabel = UILabel()
        actionTextLabel.font = .systemFont(ofSize: EAFontSize.header1FontSize.rawValue, weight: .bold)
        return actionTextLabel
    }()
    
    let goalTextField: UITextField = {
        let goalTextField = UITextField()
        goalTextField.translatesAutoresizingMaskIntoConstraints = false
        goalTextField.backgroundColor = .blue
        return goalTextField
    }()
    
    let connectorTextLabel: UILabel = {
        let connectorTextLabel = UILabel()
        connectorTextLabel.translatesAutoresizingMaskIntoConstraints = false
        connectorTextLabel.font = .systemFont(ofSize: EAFontSize.header1FontSize.rawValue, weight: .bold)
        return connectorTextLabel
    }()
    
    let numDaysTextField: UITextField = {
        let numDaysTextField = UITextField()
        numDaysTextField.translatesAutoresizingMaskIntoConstraints = false
        numDaysTextField.backgroundColor = .blue
        return numDaysTextField
    }()
    
    let numDaysUnitLabel: UILabel = {
        let numDaysUnitLabel = UILabel()
        numDaysUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        numDaysUnitLabel.font = .systemFont(ofSize: EAFontSize.header1FontSize.rawValue, weight: .bold)
        return numDaysUnitLabel
    }()
    
    init(viewModel: EACreateGoalQuestionViewModel) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.spacing = 5
        self.distribution = .fillEqually
        
        self.actionTextLabel.text = viewModel.actionText
        self.goalTextField.placeholder = viewModel.goalPlaceholderText
        self.connectorTextLabel.text = viewModel.connectorText
        self.numDaysTextField.placeholder = viewModel.numDaysPlaceholderText
        self.numDaysUnitLabel.text = viewModel.numDaysUnitLabel
        
        self.addSubviewsAndEstablishConstraints()
    }
    /// Add the subviews to the view and establish constraints
    private func addSubviewsAndEstablishConstraints() {
        let dayHStackView = UIStackView()
        dayHStackView.axis = .horizontal
        dayHStackView.spacing = 5
        dayHStackView.distribution = .fillEqually
        dayHStackView.addArrangedSubview(self.connectorTextLabel)
        dayHStackView.addArrangedSubview(self.numDaysTextField)
        dayHStackView.addArrangedSubview(self.numDaysUnitLabel)
        
        self.addArrangedSubview(self.actionTextLabel)
        self.addArrangedSubview(self.goalTextField)
        self.addArrangedSubview(dayHStackView)
        
        NSLayoutConstraint.activate([
//            self.actionTextLabel.heightAnchor.constraint(equalToConstant: 60),
//            self.goalTextField.heightAnchor.constraint(equalToConstant: 60),
//            dayHStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

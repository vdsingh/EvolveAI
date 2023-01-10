//
//  EACreateGoalQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit
class EACreateGoalQuestionView: UIStackView,  EAFormQuestionView {
    /// The required height of the View
    var requiredHeight: CGFloat = 190
    
    /// Label describing the action text (ex: "I am going to")
    let actionTextLabel: UILabel = {
        let actionTextLabel = UILabel()
        actionTextLabel.font = .systemFont(ofSize: EAFontSize.header1FontSize.rawValue, weight: .bold)
        return actionTextLabel
    }()
    
    /// TextField where user must enter their goal (ex: "learn the violin")
    let goalTextField: UITextField = {
        let goalTextField = UITextField()
        goalTextField.translatesAutoresizingMaskIntoConstraints = false
        goalTextField.backgroundColor = .blue
        return goalTextField
    }()
    
    /// Label describing the connector text (ex: "within")
    let connectorTextLabel: UILabel = {
        let connectorTextLabel = UILabel()
        connectorTextLabel.translatesAutoresizingMaskIntoConstraints = false
        connectorTextLabel.font = .systemFont(ofSize: EAFontSize.header1FontSize.rawValue, weight: .bold)
        return connectorTextLabel
    }()
    
    /// TextField where user must ender the number of days for the goal (ex: "30")
    let numDaysTextField: UITextField = {
        let numDaysTextField = UITextField()
        numDaysTextField.translatesAutoresizingMaskIntoConstraints = false
        numDaysTextField.backgroundColor = .blue
        return numDaysTextField
    }()
    
    /// Labl describing the unit for the number of days (ex: "days.")
    let numDaysUnitLabel: UILabel = {
        let numDaysUnitLabel = UILabel()
        numDaysUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        numDaysUnitLabel.font = .systemFont(ofSize: EAFontSize.header1FontSize.rawValue, weight: .bold)
        return numDaysUnitLabel
    }()
    
    /// ViewModel initializer
    /// - Parameter viewModel: The ViewModel used to display the correct information
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
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

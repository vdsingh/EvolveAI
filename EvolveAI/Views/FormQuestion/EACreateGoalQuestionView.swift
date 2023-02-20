//
//  EACreateGoalQuestionView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit

/// A Form Question to ask users to specify details of a goal they want to create.
class EACreateGoalQuestionView: UIStackView, EAUIElementView {

    /// The required height of the View
    var requiredHeight: CGFloat = 150

    /// Callback to use when the goal textfield has been edited.
    private var goalEditedCallback: (EATextField) -> Void

    /// Callback to use when the goal textfield has been edited.
    private var numDaysEditedCallback: (EATextField) -> Void

    private struct Constants {
        static let labelFontSize = EAIncrement.two.rawValue
        static let labelFontWeight = UIFont.Weight.bold
    }

    /// Label describing the action text (ex: "I am going to")
    private let actionTextLabel: UILabel = {
        let actionTextLabel = UILabel()
        actionTextLabel.font = .systemFont(
            ofSize: EACreateGoalQuestionView.Constants.labelFontSize,
            weight: EACreateGoalQuestionView.Constants.labelFontWeight
        )
        return actionTextLabel
    }()

    /// TextField where user must enter their goal (ex: "learn the violin")
    private lazy var goalTextField: EATextField = {
        let goalTextField = EATextField(textWasEditedCallback: self.goalEditedCallback, borderColor: .systemGray)
        return goalTextField
    }()

    /// Label describing the connector text (ex: "within")
    private let connectorTextLabel: UILabel = {
        let connectorTextLabel = UILabel()
        connectorTextLabel.translatesAutoresizingMaskIntoConstraints = false
        connectorTextLabel.font = .systemFont(
            ofSize: EACreateGoalQuestionView.Constants.labelFontSize,
                                              weight: EACreateGoalQuestionView.Constants.labelFontWeight
        )
        return connectorTextLabel
    }()

    /// TextField where user must ender the number of days for the goal (ex: "30")
    private lazy var numDaysTextField: EATextField = {
        let numDaysTextField = EATextField(textWasEditedCallback: self.numDaysEditedCallback, borderColor: .systemGray)
        numDaysTextField.textAlignment = .center
        numDaysTextField.keyboardType = .asciiCapableNumberPad
        return numDaysTextField
    }()

    /// Labl describing the unit for the number of days (ex: "days.")
    private let numDaysUnitLabel: UILabel = {
        let numDaysUnitLabel = UILabel()
        numDaysUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        numDaysUnitLabel.font = .systemFont(
            ofSize: EACreateGoalQuestionView.Constants.labelFontSize,
                                            weight: EACreateGoalQuestionView.Constants.labelFontWeight
        )
        numDaysUnitLabel.textAlignment = .right
        return numDaysUnitLabel
    }()

    /// ViewModel initializer
    /// - Parameter viewModel: The ViewModel used to display the correct information
    init(viewModel: EACreateGoalQuestionViewModel) {
        self.numDaysEditedCallback = viewModel.numDaysEditedCallback
        self.goalEditedCallback = viewModel.goalEditedCallback
        super.init(frame: .zero)
        self.setUIProperties(viewModel: viewModel)
        self.addSubviewsAndEstablishConstraints()
    }

    /// Sets the UI properties for this View
    /// - Parameter viewModel: The ViewModel contains the information to assign for the properties
    private func setUIProperties(viewModel: EACreateGoalQuestionViewModel) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.spacing = EAIncrement.one.rawValue
        self.distribution = .fillEqually

        self.actionTextLabel.text = viewModel.actionText
        self.goalTextField.placeholder = viewModel.goalPlaceholderText
        self.connectorTextLabel.text = viewModel.connectorText
        self.numDaysTextField.placeholder = viewModel.numDaysPlaceholderText
        self.numDaysUnitLabel.text = viewModel.numDaysUnitLabel
    }

    /// Add the subviews to the view and establish constraints
    private func addSubviewsAndEstablishConstraints() {
        let dayHStackView = UIStackView()
        dayHStackView.translatesAutoresizingMaskIntoConstraints = false
        dayHStackView.axis = .horizontal
        dayHStackView.spacing = 5
        dayHStackView.distribution = .fillEqually
        dayHStackView.alignment = .fill
        dayHStackView.addArrangedSubview(self.connectorTextLabel)
        dayHStackView.addArrangedSubview(self.numDaysTextField)
        dayHStackView.addArrangedSubview(self.numDaysUnitLabel)

        self.addArrangedSubview(self.actionTextLabel)
        self.addArrangedSubview(self.goalTextField)
        self.addArrangedSubview(dayHStackView)
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

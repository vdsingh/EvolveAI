//
//  EAGoalTaskView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/23/23.
//

import Foundation
import UIKit

/// View that displays an individual task for a goal
class EAGoalTaskView: UIStackView {

    /// A label displaying the task's text
    private let taskLabel: UILabel = {
        let taskLabel = UILabel(frame: .zero)
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.numberOfLines = 0
        return taskLabel
    }()

    /// A checkbox indicating whether the task has been marked complete (and giving user opportunity to mark it)
    private let checkbox: EACheckbox = {
        let checkbox = EACheckbox(size: EAIncrement.two.rawValue * 2 / 3)
        return checkbox
    }()

    /// StackView that lets us add a UIView above the checkbox for padding
    private lazy var checkboxStack: UIStackView = {
        let checkboxPadding = UIView()
        checkboxPadding.translatesAutoresizingMaskIntoConstraints = false
        let checkboxStack = UIStackView()
        checkboxStack.translatesAutoresizingMaskIntoConstraints = false
        checkboxStack.axis = .vertical
        checkboxStack.addArrangedSubview(checkboxPadding)
        checkboxStack.addArrangedSubview(self.checkbox)
        checkboxPadding.heightAnchor.constraint(equalToConstant: EAIncrement.one.rawValue / 3).isActive = true
        return checkboxStack
    }()

    init(viewModel: EAGoalTaskViewModel) {
        super.init(frame: .zero)
        self.addSubviewsAndEstablishConstraints()
        self.configure(with: viewModel)
    }

    /// Adds the relevant subviews and establishes constraints
    private func addSubviewsAndEstablishConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.alignment = .top
        self.spacing = EAIncrement.one.rawValue
        self.addArrangedSubview(checkboxStack)
        self.addArrangedSubview(taskLabel)
    }

    /// Configures this View with a ViewModel
    /// - Parameter viewModel: The EAGoalTaskViewModel that corresponds to this View
    private func configure(with viewModel: EAGoalTaskViewModel) {
        self.updateTaskUI(with: viewModel)
        self.checkbox.setCheckboxHandler { [weak self] complete in
            viewModel.toggleTaskCompletion(complete: complete)
            self?.updateTaskUI(with: viewModel)
        }
    }

    private func updateTaskUI(with viewModel: EAGoalTaskViewModel) {
        self.checkbox.setActive(active: viewModel.complete)
        self.taskLabel.attributedText = viewModel.attributedText
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

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

    /// Initializer for EAGoalTaskViews that should be configured with a ViewModel later
    init() {
        super.init(frame: .zero)
        self.addSubviewsAndEstablishConstraints()
    }

    /// Initializer for EAGoalTaskViews that can be configured with a ViewModel immediately
    /// - Parameter viewModel: The ViewModel used to configure the TaskView
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

    /// Updates the UI of this View with a ViewModel
    /// - Parameter viewModel: The ViewModel that supplies the information for this View
    private func updateTaskUI(with viewModel: EAGoalTaskViewModel) {
        self.checkbox.setActive(active: viewModel.complete)
        self.taskLabel.attributedText = viewModel.attributedText
    }

    /// Configures this View with a ViewModel
    /// - Parameter viewModel: The EAGoalTaskViewModel that corresponds to this View
    func configure(with viewModel: EAGoalTaskViewModel) {
        self.updateTaskUI(with: viewModel)
        self.checkbox.setCheckboxHandler { [weak self] complete in
            viewModel.toggleTaskCompletion(complete: complete)
            self?.updateTaskUI(with: viewModel)
        }
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

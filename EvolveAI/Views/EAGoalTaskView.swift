//
//  EAGoalTaskView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/23/23.
//

import Foundation
import UIKit

// TODO: Docstrings

class EAGoalTaskView: UIStackView {
    let taskLabel: UILabel = {
        let taskLabel = UILabel(frame: .zero)
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.numberOfLines = 0
        return taskLabel
    }()

    let checkbox: EACheckbox = {
        let checkbox = EACheckbox(size: EAIncrement.two.rawValue * 2/3)
        return checkbox
    }()

    lazy var checkboxStack: UIStackView = {
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

    private func addSubviewsAndEstablishConstraints() {
//        let taskStackView = UIStackView()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.alignment = .top
        self.spacing = EAIncrement.one.rawValue
        self.addArrangedSubview(checkboxStack)
        self.addArrangedSubview(taskLabel)
    }

    private func configure(with viewModel: EAGoalTaskViewModel) {
        self.taskLabel.text = viewModel.text
        self.checkbox.setActive(active: viewModel.complete)
        self.checkbox.setCheckboxHandler(checkboxWasToggled: viewModel.toggleTaskCompletion)
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

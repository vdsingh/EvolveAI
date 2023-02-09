//
//  EAGoalCollectionViewCell.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/14/23.
//

import UIKit

/// A UICollectionViewCell to hold EAGoal information
class EAGoalListItemCollectionViewCell: UICollectionViewCell {

    /// Reuse identifier for the cell
    static let reuseIdentifier = "EAGoalCollectionViewCell"

    /// Displays the EAGoal title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: EAIncrement.one.rawValue * 1.5, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    /// Displays the EAGoal number of days
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    // TODO: Docstring
    private let nextTaskLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    private let nextTaskView: EAGoalTaskView = {
        let nextTaskView = EAGoalTaskView()
        return nextTaskView
    }()

    /// Spinner for if the goal is loading
    private let spinner: EASpinner = {
        let spinner = EASpinner(backgroundColor: .systemGray)
        spinner.stopAnimating()
        return spinner
    }()

    // MARK: - Private Functions

    /// Adds subviews and establishes constraints for this view
    private func addSubviewsAndEstablishConstraints() {
        // Add Spinner for when goal is loading
        let goalInfoStackView = self.createStackView(with: [
            self.titleLabel,
            self.daysLabel
        ])

        let nextTaskStackView = self.createStackView(with: [
            self.nextTaskLabel,
            self.nextTaskView
        ])

        let mainStackView = self.createStackView(with: [
            goalInfoStackView,
            nextTaskStackView
        ])
        mainStackView.backgroundColor = .systemGray

        self.addSubview(mainStackView)
        self.addSubview(self.spinner)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: EAIncrement.one.rawValue),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -EAIncrement.one.rawValue),
            mainStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: EAIncrement.one.rawValue),
            mainStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -EAIncrement.one.rawValue),

            self.spinner.topAnchor.constraint(equalTo: self.topAnchor),
            self.spinner.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.spinner.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.spinner.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    /// Sets UI properties for this View
    /// - Parameter viewModel: The ViewModel which supplies the data
    private func setUIProperties(viewModel: EAGoalListItemViewModel) {
        self.backgroundColor = viewModel.color
        self.layer.cornerRadius = EAIncrement.two.rawValue
        self.titleLabel.text = viewModel.title
        self.daysLabel.text = "\(viewModel.numDays) days"
        if let nextTaskViewModel = viewModel.nextTaskViewModel {
            self.nextTaskLabel.text = "Next Task (Day 2)"
            //        let taskViewModel = EAGoalTaskViewModel(task: viewModel.nextTask, viewModel.goalsService)
            self.nextTaskView.configure(with: nextTaskViewModel)
            print("$Log: configuring next task: \(nextTaskViewModel.text)")
        } else {
            print("$Log: no detected next task for goal \(viewModel.title).")
        }
        
        if viewModel.loading {
            self.spinner.startAnimating()
        } else {
            self.spinner.stopAnimating()
        }
    }

    // TODO: Docstring
    private func createStackView(with views: [UIView]) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        for view in views {
            stack.addArrangedSubview(view)
        }
        return stack
    }

    // MARK: - Public Functions

    /// Configures the cell with a given ViewModel
    /// - Parameter viewModel: The ViewModel with which to configure the cell
    public func configure(with viewModel: EAGoalListItemViewModel) {
        self.addSubviewsAndEstablishConstraints()
        self.setUIProperties(viewModel: viewModel)
    }
}

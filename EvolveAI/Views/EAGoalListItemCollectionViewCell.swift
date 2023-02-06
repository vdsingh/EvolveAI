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
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: EAIncrement.one.rawValue * 1.5, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    /// Displays the EAGoal number of days
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    /// Adds subviews and establishes constraints for this view
    private func addSubviewsAndEstablishConstraints() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.daysLabel)
        self.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8),
            self.daysLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8)
        ])
    }

    /// Sets UI properties for this View
    /// - Parameter viewModel: The ViewModel which supplies the data
    private func setUIProperties(viewModel: EAGoalListItemViewModel) {
        self.backgroundColor = viewModel.color
        self.layer.cornerRadius = EAIncrement.two.rawValue
        self.titleLabel.text = viewModel.title
        self.daysLabel.text = "\(viewModel.numDays) days"
    }

    /// Configures the cell with a given ViewModel
    /// - Parameter viewModel: The ViewModel with which to configure the cell
    public func configure(with viewModel: EAGoalListItemViewModel) {
        self.addSubviewsAndEstablishConstraints()
        self.setUIProperties(viewModel: viewModel)
    }
}

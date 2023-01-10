//
//  EAGoalTableViewCell.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import UIKit

/// UITableViewCell to display EAGoal
class EAGoalTableViewCell: UITableViewCell {
    
    /// Reuse Identifier for this cell
    static let reuseIdentifier = "EAGoalTableViewCell"
    
    /// UILabel to display the title of the goal
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    /// UILabel to display the number of days of the goal
    let numDaysLabel: UILabel = {
        let numDaysLabel = UILabel()
        numDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        return numDaysLabel
    }()
    
    /// Adds the subviews and establishes the constraints
    private func addViewsAndEstablishConstraints() {
        addSubview(titleLabel)
        addSubview(numDaysLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            numDaysLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numDaysLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            numDaysLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    /// Sets up the view with an EAGoalViewModel
    /// - Parameter viewModel: the ViewModel specifiying the cells display
    public func configure(with viewModel: EAGoalViewModel) {
        addViewsAndEstablishConstraints()
        titleLabel.text = viewModel.title
        numDaysLabel.text = "\(viewModel.numDays) days"
    }
}

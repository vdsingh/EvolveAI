//
//  EAGoalCollectionViewCell.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/14/23.
//

import UIKit

/// A UICollectionViewCell to hold EAGoal information
class EAGoalCollectionViewCell: UICollectionViewCell {
    
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
        self.addSubview(self.titleLabel)
        self.addSubview(self.daysLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: EAIncrement.one.rawValue * 1.5),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: EAIncrement.one.rawValue * 1.5),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -EAIncrement.one.rawValue * 1.5),
            
            self.daysLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -EAIncrement.one.rawValue * 1.5),
            self.daysLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: EAIncrement.one.rawValue * 1.5),
            self.daysLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -EAIncrement.one.rawValue * 1.5),
        ])
    }
    
    /// Sets UI properties for this View
    /// - Parameter viewModel: The ViewModel which supplies the data
    private func setUIProperties(viewModel: EAGoalViewModel) {
        self.backgroundColor = .systemPurple
        self.layer.cornerRadius = EAIncrement.two.rawValue
        self.titleLabel.text = viewModel.title
        self.daysLabel.text = "\(viewModel.numDays) days"
    }
    
    /// Configures the cell with a given ViewModel
    /// - Parameter viewModel: The ViewModel with which to configure the cell
    public func configure(with viewModel: EAGoalViewModel) {
        self.addSubviewsAndEstablishConstraints()
        self.setUIProperties(viewModel: viewModel)
    }
}

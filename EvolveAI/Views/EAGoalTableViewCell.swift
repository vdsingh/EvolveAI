//
//  EAGoalTableViewCell.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import UIKit

class EAGoalTableViewCell: UITableViewCell {
    static let reuseIdentifier = "EAGoalTableViewCell"
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let numDaysLabel: UILabel = {
        let numDaysLabel = UILabel()
        numDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        return numDaysLabel
    }()

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
    
    public func configure(with viewModel: EAGoalViewModel) {
        addViewsAndEstablishConstraints()
        
        titleLabel.text = viewModel.title
        numDaysLabel.text = "\(viewModel.numDays) days"
    }
}

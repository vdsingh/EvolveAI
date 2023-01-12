//
//  EAGoalView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

/// View to display an individual goal and all of its information
class EAGoalView: UIView {
    
    /// The ViewModel to use for the View's data
    let goalViewModel: EAGoalViewModel
    
    let numDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: EAIncrement.two.rawValue, weight: .regular)
        return label
    }()
    
    let guideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .yellow
        label.font = .systemFont(ofSize: EAIncrement.two.rawValue, weight: .regular)
        return label
    }()
    
    /// Initializer to instantiate this View with a ViewModel
    /// - Parameter viewModel: The ViewModel to use for the View's data
    init(viewModel: EAGoalViewModel) {
        self.goalViewModel = viewModel
        self.numDaysLabel.text = "within \(viewModel.numDays) Days:"
        print("View model guide: \(viewModel.guideText)")
        self.guideLabel.text = "Plan: \(viewModel.guideText)"
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.addSubviewsAndEstablishConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    /// The ViewModel to use for the View's data
    private func addSubviewsAndEstablishConstraints() {
        self.addSubview(self.numDaysLabel)
        self.addSubview(self.guideLabel)
        NSLayoutConstraint.activate([
            self.numDaysLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            self.numDaysLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: EAIncrement.two.rawValue),
            self.numDaysLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: EAIncrement.two.rawValue),
            
            self.guideLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            self.guideLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: EAIncrement.two.rawValue),
            self.guideLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: EAIncrement.two.rawValue),
            self.guideLabel.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
}

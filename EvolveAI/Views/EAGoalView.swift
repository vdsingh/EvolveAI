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
    
    let guideScrollView: UIScrollView = {
        let guideScrollView = UIScrollView()
        guideScrollView.translatesAutoresizingMaskIntoConstraints = false
        guideScrollView.showsVerticalScrollIndicator = true
        return guideScrollView
    }()

    let guideContentView: UIStackView = {
        let guideContentView = UIStackView()
        guideContentView.translatesAutoresizingMaskIntoConstraints = false
        guideContentView.axis = .vertical
        guideContentView.alignment = .fill
        guideContentView.distribution = .equalSpacing
        guideContentView.spacing = EAIncrement.one.rawValue / 2
        return guideContentView
    }()
    
    let guideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: EAIncrement.two.rawValue, weight: .regular)
        return label
    }()
    
    /// Initializer to instantiate this View with a ViewModel
    /// - Parameter viewModel: The ViewModel to use for the View's data
    init(viewModel: EAGoalViewModel) {
        self.goalViewModel = viewModel
        self.numDaysLabel.text = "within \(viewModel.numDays) Days:"
        self.guideLabel.text = "\(viewModel.guideText)"
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.addSubviewsAndEstablishConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    /// Adds the subviews of the View and activates the constraints
    private func addSubviewsAndEstablishConstraints() {
        self.addSubview(guideScrollView)
        self.guideScrollView.addSubview(guideContentView)
        self.guideContentView.addArrangedSubview(self.numDaysLabel)
        self.guideContentView.addArrangedSubview(self.guideLabel)
        NSLayoutConstraint.activate([
            self.guideScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            self.guideScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.guideScrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: EAIncrement.two.rawValue),
            self.guideScrollView.rightAnchor.constraint(equalTo: rightAnchor, constant: -EAIncrement.two.rawValue),

            self.guideContentView.topAnchor.constraint(equalTo: guideScrollView.topAnchor),
            self.guideContentView.bottomAnchor.constraint(equalTo: guideScrollView.bottomAnchor),
            self.guideContentView.leftAnchor.constraint(equalTo: guideScrollView.leftAnchor),
            self.guideContentView.rightAnchor.constraint(equalTo: guideScrollView.rightAnchor),
            self.guideContentView.widthAnchor.constraint(equalTo: guideScrollView.widthAnchor)
        ])
    }
}

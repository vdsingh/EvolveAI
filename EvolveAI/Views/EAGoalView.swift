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
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NOT SET"
        return label
    }()
    
    /// Initializer to instantiate this View with a ViewModel
    /// - Parameter viewModel: The ViewModel to use for the View's data
    init(viewModel: EAGoalViewModel) {
        self.goalViewModel = viewModel
        label.text = self.goalViewModel.title
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        addSubviewsAndEstablishConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    /// The ViewModel to use for the View's data
    private func addSubviewsAndEstablishConstraints() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            label.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            label.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

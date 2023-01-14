//
//  EAGoalViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

/// ViewController for screen for viewing a single goal's information
class EAGoalViewController: UIViewController {
    
    /// The EAGoal that we are focused on
    let goal: EAGoal
    
    /// Normal Initializer
    /// - Parameter goal: The goal that we are focused on
    init(goal: EAGoal) {
        self.goal = goal
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Loads the View
    override func loadView() {
        let viewModel = EAGoalViewModel(title: goal.goal,
                                        numDays: goal.numDays,
                                        dayGuides: goal.dayGuides)
        let goalView = EAGoalView(viewModel: viewModel)
        view = goalView
        self.title = viewModel.title
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

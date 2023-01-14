//
//  EAGoalViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit
class EAGoalViewController: UIViewController {
    let goal: EAGoal
    init(goal: EAGoal) {
        self.goal = goal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        let viewModel = EAGoalViewModel(title: goal.goal,
                                        numDays: goal.numDays,
                                        dayGuides: goal.dayGuides)
        let goalView = EAGoalView(viewModel: viewModel)
        view = goalView
        self.title = viewModel.title
    }
}

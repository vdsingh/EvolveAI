//
//  GoalsNavigator.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit
/// Handles navigation from GoalsList View
class GoalsListNavigator: Navigator {
    /// Represents the destinations that can be reached from this navigator
    enum Destination {
        case viewGoal(goal: EAGoal)
        case createGoal
    }

    /// in some situations the navigation controller could end up causing a retain cycle.
    private weak var navigationController: UINavigationController?

    // MARK: - Initializer
    
    /// Navigator must be instantiated with a UINavigationController so we can push new screens
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Navigator
    
    /// Main function used to navigate to new screens
    /// - Parameter destination: The screen that we want to navigate to
    public func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Private
    
    /// Helper function to construct destination ViewControllers
    /// - Parameter destination: The destination screen we want to reach
    /// - Returns: A UIViewController as the destination
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .viewGoal(let goal):
            return EAGoalViewController(goal: goal)
        case .createGoal:
            return EAGoalCreationFormViewController()
        }
    }
}

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
        case viewGoal(goalViewModel: EAGoalDetailsViewModel)
        case createGoal(goalWasCreated: () -> Void)
    }

    /// in some situations the navigation controller could end up causing a retain cycle.
    private weak var navigationController: UINavigationController?

    /// Service to pass to ViewControllers to interact with Goals and other relevant types
    private let goalsService: EAGoalsService

    // MARK: - Initializer

    /// Navigator must be instantiated with a UINavigationController so we can push new screens
    init(navigationController: UINavigationController, goalsService: EAGoalsService) {
        self.navigationController = navigationController
        self.goalsService = goalsService
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
        case .viewGoal(let goalViewModel):
            return EAGoalDetailsViewController(viewModel: goalViewModel)

        case .createGoal(let goalWasCreated):
            return EAGoalCreationFormViewController(goalWasCreated: goalWasCreated, goalsService: self.goalsService)
        }
    }
}

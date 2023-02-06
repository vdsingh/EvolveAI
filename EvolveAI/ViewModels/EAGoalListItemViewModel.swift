//
//  EAGoalViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import Foundation
import RealmSwift
import UIKit

/// Possible inputs to this ViewModel
protocol EAGoalListItemViewModelInput {

    /// Handler for when a goal list item was tapped
    func listItemWasTapped()
}

/// Properties that can be extracted from this ViewModel
protocol EAGoalListItemViewModelOutput {
    /// The title of the goal
    var title: String { get }

    /// The number of days of the goal
    var numDays: Int { get }

    /// The goal color
    var color: UIColor { get }
}

protocol EAGoalListItemViewModel: EAGoalListItemViewModelInput, EAGoalListItemViewModelOutput { }

/// Actions that can occur involving the View
struct EAGoalListItemViewModelActions {

    /// Function for when we want to show the details screen for an EAGoal
    let showGoalDetails: (EAGoal) -> Void
}

/// A ViewModel for EAGoals
final class DefaultEAGoalListItemViewModel: EAGoalListItemViewModel {
    var title: String
    var numDays: Int
    var color: UIColor

    /// Actions that this ViewModel may need to handle
    private let actions: EAGoalListItemViewModelActions?

    /// The goal that this ViewModel represents
    private var goal: EAGoal? {
        didSet {
            if let goal = self.goal {
                self.setGoalValues(goal: goal)
            }
        }
    }

    /// Common initializer
    /// - Parameters:
    ///   - title: The title of the goal
    ///   - numDays: The number of days of the goal
    ///   - color: The goal color
    init(
        goal: EAGoal,
        actions: EAGoalListItemViewModelActions?
    ) {
        self.goal = goal
        self.title = goal.goal
        self.numDays = goal.numDays
        self.color = goal.color
        self.actions = actions
    }

    init(
        title: String,
        numDays: Int,
        color: UIColor,
        actions: EAGoalListItemViewModelActions?
    ) {
        self.title = title
        self.numDays = numDays
        self.color = color
        self.actions = actions
    }

    private func setGoalValues(goal: EAGoal) {
        self.title = goal.goal
        self.numDays = goal.numDays
        self.color = goal.color
    }
}

extension DefaultEAGoalListItemViewModel {
    func listItemWasTapped() {
        if let goal = self.goal {
            self.actions?.showGoalDetails(goal)
        }
    }
}

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
    var colorHex: String { get }
}

protocol EAGoalListItemViewModel: EAGoalListItemViewModelInput, EAGoalListItemViewModelOutput { }

struct EAGoalListItemViewModelActions {

    /// Function for when we want to show the details screen for an EAGoal
    let showGoalDetails: (EAGoal) -> Void
}

/// A ViewModel for EAGoals
final class DefaultEAGoalListItemViewModel: EAGoalListItemViewModel {

    let title: String
    let numDays: Int
    let colorHex: String

    /// Actions that this ViewModel may need to handle
    private let actions: EAGoalListItemViewModelActions?

    /// The goal that this ViewModel represents
    private let goal: EAGoal

    /// Common initializer
    /// - Parameters:
    ///   - title: The title of the goal
    ///   - numDays: The number of days of the goal
    ///   - colorHex: The goal color
    init(
        goal: EAGoal,
        actions: EAGoalListItemViewModelActions?
    ) {
        self.title = goal.goal
        self.numDays = goal.numDays
        self.colorHex = goal.colorHex
        self.actions = actions
        self.goal = goal
    }
}

extension DefaultEAGoalListItemViewModel {
    func listItemWasTapped() {
        self.actions?.showGoalDetails(self.goal)
    }
}

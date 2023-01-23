//
//  EAGoalViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import Foundation
import RealmSwift
import UIKit

// TODO: Fix docstrings

protocol EAGoalListItemViewModelInput {
    func wasTapped()
}

protocol EAGoalListItemViewModelOutput {
    var title: String { get }
    var numDays: Int { get }
    var colorHex: String { get }
}

protocol EAGoalListItemViewModel: EAGoalListItemViewModelInput, EAGoalListItemViewModelOutput { }

struct EAGoalListItemViewModelActions {

    /// Function for when we want to show the details screen for an EAGoal
    let showGoalDetails: (EAGoal) -> Void
}

/// A ViewModel for EAGoals
final class DefaultEAGoalListItemViewModel: EAGoalListItemViewModel {

    /// The title of the goal
    let title: String

    /// The number of days of the goal
    let numDays: Int

    /// The goal color
    let colorHex: String

    private let actions: EAGoalListItemViewModelActions?

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
    func wasTapped() {
        self.actions?.showGoalDetails(self.goal)
    }
}

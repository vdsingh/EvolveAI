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

    /// Whether the goal is loading or not
    var loading: Bool { get }

    // TODO: Docstrings
    var currentDayNumber: Int? { get }

    var nextTaskViewModel: EAGoalTaskViewModel? { get }

    var tags: [String] { get }
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
    var loading: Bool {
        goal == nil
    }
    // Computable (use today's date, the goal start date, subtract)
    var currentDayNumber: Int? {
        // TODO: Fix
//        if let goal = self.goal {
//            return Date().distance(to: goal.startDate).significandWidth + 1
//        }
//
//        return nil
        return 1
    }

    var nextTaskViewModel: EAGoalTaskViewModel? {
        if let task = self.nextTask {
            return DefaultEAGoalTaskViewModel(task: task, goalsService: self.goalsService)
        }

        return nil
    }

    var tags: [String] {
        goal?.tags ?? []
    }

    /// Actions that this ViewModel may need to handle
    private let actions: EAGoalListItemViewModelActions?

    private let goalsService: EAGoalsService

    /// The goal that this ViewModel represents
    private var goal: EAGoal? {
        didSet {
            if let goal = self.goal {
                self.setGoalValues(goal: goal)
            }
        }
    }

    private var nextTask: EAGoalTask? {
        return self.todaysDayGuide?.tasks.first(where: { task in
            !task.complete
        })
    }

    private var todaysDayGuide: EAGoalDayGuide? {
        if let dayNumber = self.currentDayNumber {
            return goal?.dayGuides.first(where: { dayGuide in
                return dayGuide.days.contains(dayNumber)
            })
        }

        return nil
    }

    /// Common initializer
    /// - Parameters:
    ///   - title: The title of the goal
    ///   - numDays: The number of days of the goal
    ///   - color: The goal color
    init(
        goal: EAGoal,
        actions: EAGoalListItemViewModelActions?,
        goalsService: EAGoalsService
    ) {
        self.goal = goal
        self.title = goal.goal
        self.numDays = goal.numDays
        self.color = goal.color

        self.actions = actions
        self.goalsService = goalsService
    }

    init(
        title: String,
        numDays: Int,
        color: UIColor,
        actions: EAGoalListItemViewModelActions?,
        goalsService: EAGoalsService
    ) {
        self.title = title
        self.numDays = numDays
        self.color = color
        self.actions = actions
        self.goalsService = goalsService
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

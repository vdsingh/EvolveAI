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

    /// The secondary (darker) goal color
    var darkColor: UIColor { get }

    /// Whether the goal is loading or not
    var loading: Bool { get }

    // TODO: docstrings
    /// The current day number for the goal
    var dayNumberText: String? { get }

    /// A ViewModel that represents the next task to complete
    var nextTaskViewModel: EAGoalTaskViewModel? { get }

    /// The tags for the goal
    var tags: [String] { get }
}

protocol EAGoalListItemViewModel: EAGoalListItemViewModelInput, EAGoalListItemViewModelOutput { }

/// Actions that can occur involving the View
struct EAGoalListItemViewModelActions {

    /// Function for when we want to show the details screen for an EAGoal
    let showGoalDetails: (EAGoal) -> Void
}

/// A ViewModel for EAGoals
final class DefaultEAGoalListItemViewModel: EAGoalListItemViewModel, Debuggable {
    let debug: Bool = true

    var title: String
    var numDays: Int
    var color: UIColor
    var darkColor: UIColor {
        color.darker() ?? .link
    }

    var loading: Bool {
        goal == nil
    }

    // TODO: computable (use today's date, the goal start date, subtract)
    var dayNumberText: String? {
        if let dayGuideViewModel = self.dayGuideViewModel {
            return dayGuideViewModel.dayNumbersText
        }

        return nil
    }

//    var nextTaskViewModel: EAGoalTaskViewModel? {
//        if let task = self.nextTask {
//            return DefaultEAGoalTaskViewModel(task: task, textColor: self.darkColor, goalsService: self.goalsService)
//        }
//    }

    var tags: [String] {
        self.goal?.tags ?? []
    }

    /// Actions that this ViewModel may need to handle
    private let actions: EAGoalListItemViewModelActions?

    // TODO: Docstring

    private let goalsService: EAGoalsService

    /// The goal that this ViewModel represents
    private var goal: EAGoal? {
        didSet {
            if let goal = self.goal {
                self.setGoalValues(goal: goal)
            }
        }
    }

    // TODO: Docstring

    private var dayGuideViewModel: EAGoalDayGuideViewModel?

    var nextTaskViewModel: EAGoalTaskViewModel? {
        if let dayGuideViewModel = self.dayGuideViewModel {
            return dayGuideViewModel.taskViewModels.first(where: { taskViewModel in
                !taskViewModel.complete
            })
        } else {
            printDebug("EAGoalListItem dayGuideViewModel is nil. This means there is not a day guide for today or the goal is still loading.")
        }

        return nil
//        return self.todaysDayGuide?.tasks.first(where: { task in
//            !task.complete
//        })
    }

//    private var todaysDayGuide: EAGoalDayGuide? {
//        return goal.dayGuides.first(where: { dayGuide in
//            return dayGuide.days.contains(self.currentDayNumber?)
//        })
//    }

    // TODO: update docstring params

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

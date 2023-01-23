//
//  EAGoalTaskViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/22/23.
//

import Foundation

/// Possible inputs for this ViewModel
protocol EAGoalTaskViewModelInput {

    /// Handler for when a task's completion status has been toggled
    /// - Parameter complete: Whether the task has been marked as complete or not
    func toggleTaskCompletion(complete: Bool)
}

/// Properties that can be extracted from this ViewModel
protocol EAGoalTaskViewModelOutput {

    /// The text for the task
    var text: String { get }

    /// Whether the task is complete or not
    var complete: Bool { get }
}

protocol EAGoalTaskViewModel: EAGoalTaskViewModelInput, EAGoalTaskViewModelOutput { }

/// Default ViewModel which conforms to the required input/output protocols
final class DefaultEAGoalTaskViewModel: EAGoalTaskViewModel {

    /// The task that this ViewModel represents
    private let task: EAGoalTask

    /// A service to interact with goals and other related types (Task!)
    private let goalsService: EAGoalsService

    let text: String
    var complete: Bool

    init(task: EAGoalTask, goalsService: EAGoalsService) {
        self.text = task.taskString
        self.goalsService = goalsService
        self.complete = task.complete
        self.task = task
    }
}

extension DefaultEAGoalTaskViewModel {
    func toggleTaskCompletion(complete: Bool) {
        goalsService.toggleTaskCompletion(task: self.task, complete: complete)
    }
}

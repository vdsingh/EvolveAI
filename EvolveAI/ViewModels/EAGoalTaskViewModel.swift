//
//  EAGoalTaskViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/22/23.
//

import Foundation

protocol EAGoalTaskViewModelInput {
    func toggleTaskCompletion(complete: Bool)
}

protocol EAGoalTaskViewModelOutput {
    var text: String { get }
    var complete: Bool { get }
}

protocol EAGoalTaskViewModel: EAGoalTaskViewModelInput, EAGoalTaskViewModelOutput { }

struct EAGoalTaskViewModelActions {
//    func taskCompletionToggled()
}

// TODO: docstrings, actions, input/output
final class DefaultEAGoalTaskViewModel: EAGoalTaskViewModel {
    private let task: EAGoalTask
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
//        self.task.complete = checked
    }
}

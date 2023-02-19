//
//  EAGoalTaskViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/22/23.
//

import Foundation
import UIKit

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
    
    /// The color for the text
    var textColor: UIColor { get }

    /// Whether the task is complete or not
    var complete: Bool { get }

    /// Attributed text for the task, which includes strikethrough
    var attributedText: NSMutableAttributedString { get }
}

protocol EAGoalTaskViewModel: EAGoalTaskViewModelInput, EAGoalTaskViewModelOutput { }

/// Default ViewModel which conforms to the required input/output protocols
final class DefaultEAGoalTaskViewModel: EAGoalTaskViewModel, Debuggable {
    let debug = true

    /// The task that this ViewModel represents
    private let task: EAGoalTask
    
    /// A service to interact with goals and other related types (Task!)
    private let goalsService: EAGoalsService

    var complete: Bool {
        return task.complete
    }

    let text: String
    let textColor: UIColor
    var attributedText: NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self.text)
        attributedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: self.textColor,
            range: NSRange(location: 0, length: attributedString.length)
        )
        if self.complete {
            attributedString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 2,
                range: NSRange(location: 0, length: attributedString.length)
            )
        }

        return attributedString
    }

    init(task: EAGoalTask, textColor: UIColor, goalsService: EAGoalsService) {
        self.text = task.taskString
        self.textColor = textColor
        self.goalsService = goalsService
        self.task = task
    }
}

extension DefaultEAGoalTaskViewModel {
    func toggleTaskCompletion(complete: Bool) {
        goalsService.toggleTaskCompletion(task: self.task, complete: complete)
        printDebug("Toggled task completion. Task completion is now \(complete)")
    }
}

extension DefaultEAGoalTaskViewModel {
    func printDebug(_ message: String) {
        if self.debug {
            print("$Log: \(message)")
        }
    }
}

//
//  EAGoalTask.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/23/23.
//

import Foundation
import RealmSwift

/// Model for tasks that exist within Goal Day Guides
final class EAGoalTask: Object {

    /// String describing the task
    @Persisted var taskString: String

    /// Whether the task has been marked as complete
    @Persisted var complete: Bool

    convenience init(taskString: String, complete: Bool) {
        self.init()
        self.taskString = taskString
        self.complete = complete
    }
}

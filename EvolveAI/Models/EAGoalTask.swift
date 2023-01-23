//
//  EAGoalTask.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/23/23.
//

import Foundation
import RealmSwift

// TODO: Docstrings
final class EAGoalTask: Object {
    @Persisted var taskString: String
    @Persisted var complete: Bool

    convenience init(taskString: String, complete: Bool) {
        self.init()
        self.taskString = taskString
        self.complete = complete
    }
}

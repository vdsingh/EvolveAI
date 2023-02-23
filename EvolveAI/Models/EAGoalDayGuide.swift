//
//  EAGoalDayGuide.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
import RealmSwift

/// Represents the guide for a given day (or set of days)
final class EAGoalDayGuide: Object {

    /// Whether the guide covers the span of multiple days (ex: 1st to 3rd) instead of single day (ex: 1st)
    @Persisted var isMultipleDays: Bool

    /// The range of days the guide covers
    @Persisted var days: List<Int>

    /// The list of tasks associated with this guide
    @Persisted var tasks: List<EAGoalTask>

    /// The start date of the goal
    @Persisted private var goalStartDate: Date

    var dayGuideDate: Date {
        let dayNumber = self.days[0]
        var dateComponent = DateComponents()
        dateComponent.day = dayNumber - 1
        if let futureDate = Calendar.current.date(byAdding: dateComponent, to: goalStartDate) {
            return futureDate
        }

        fatalError("$Error: couldn't get the date for this day guide")
    }

    /// Initializer to create an EAGoalDayGuide
    /// - Parameters:
    ///   - isMultipleDays: Whether the guide covers the span of multiple days (ex: 1st to 3rd) instead of single day (ex: 1st)
    ///   - days: The range of days the guide covers
    ///   - tasks: The list of tasks associated with this guide
    convenience init(isMultipleDays: Bool, days: List<Int>, tasks: List<EAGoalTask>, goalStartDate: Date) {
        self.init()
        self.isMultipleDays = isMultipleDays
        self.days = days
        self.tasks = tasks
        self.goalStartDate = goalStartDate
    }
}

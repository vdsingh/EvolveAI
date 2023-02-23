//
//  EADayGuideViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/13/23.
//

import Foundation
import RealmSwift
import UIKit

/// Possible inputs for this ViewModel
protocol EAGoalDayGuideViewModelInput {

}

/// The properties that can be extracted from this ViewModel
protocol EAGoalDayGuideViewModelOutput {

    /// String describing the day numbers for the associated GoalDayGuide (ex: "Day 1" or "Days 2-5")
    var dayNumbersText: String { get }

    /// String describing both the day numbers and dates for the associated GoalDayGuide
    var dayNumbersAndDatesText: String { get }

    /// A list of EAGoalTask representing the tasks for this day guide
    var taskViewModels: [EAGoalTaskViewModel] { get }

    /// The color for the goal
    var labelColor: UIColor { get }
}

protocol EAGoalDayGuideViewModel: EAGoalDayGuideViewModelInput, EAGoalDayGuideViewModelOutput { }

/// ViewModel used to show information for day guides
final class DefaultEAGoalDayGuideViewModel: EAGoalDayGuideViewModel {

    /// The EAGoalDayGuide that this ViewModel represents.
    private let dayGuide: EAGoalDayGuide

    /// The associated Goal's startDate
    private let goalStartDate: Date

    /// A service to interact with goals and other related types
    private let goalsService: EAGoalsService
    
    /// A String representing the Date for the associated GoalDayGuide
    private var currentDayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        return dateFormatter.string(from: dayGuide.dayGuideDate)
    }

    var dayNumbersText: String {
        return dayGuide.days.count > 1 ? "Days \(dayGuide.days[0]) - \(dayGuide.days[1]):" : "Day \(dayGuide.days[0])"
    }

    var dayNumbersAndDatesText: String {
        return "\(self.dayNumbersText) - (\(self.currentDayString)):"
    }

    var taskViewModels: [EAGoalTaskViewModel] {
        return dayGuide.tasks.compactMap({
            DefaultEAGoalTaskViewModel(task: $0, tintColor: self.labelColor, goalsService: self.goalsService)
        })
    }

    let labelColor: UIColor
    
    /// Normal initializer
    /// - Parameters:
    ///   - dayGuide: The associated EAGoalDayGuide
    ///   - goalStartDate: The start date of the relevant Goal
    ///   - labelColor: The color of the labels
    ///   - goalsService: The goals service
    init(dayGuide: EAGoalDayGuide, goalStartDate: Date, labelColor: UIColor, goalsService: EAGoalsService) {
        self.dayGuide = dayGuide
        self.goalStartDate = goalStartDate
        self.labelColor = labelColor
        self.goalsService = goalsService
    }
}

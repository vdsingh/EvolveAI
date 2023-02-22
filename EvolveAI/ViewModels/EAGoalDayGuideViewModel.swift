//
//  EADayGuideViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/13/23.
//

import Foundation
import RealmSwift
import UIKit

// TODO: Docstrings whole file

/// Possible inputs for this ViewModel
protocol EAGoalDayGuideViewModelInput {

}

/// The properties that can be extracted from this ViewModel
protocol EAGoalDayGuideViewModelOutput {

    /// A String that will be displayed representing the day(s) for this day guide (ex: Days 3 - 5)
    var dayNumbersText: String { get }

    // TODO: Docstrings
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

    // TODO: Docstring
    private let goalStartDate: Date

    /// A service to interact with goals and other related types
    private let goalsService: EAGoalsService

    private var currentDayString: String {
//        if let dayGuideDate = dayGuide.dayGuideDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YY"
        return dateFormatter.string(from: dayGuide.dayGuideDate)
//        }

//        return nil
    }

    // TODO: Docstring
    var dayNumbersText: String {
        return dayGuide.days.count > 1 ? "Days \(dayGuide.days[0]) - \(dayGuide.days[1]):" : "Day \(dayGuide.days[0])"
//        if let currentDayString = self.currentDayString {

//        }

//        return dayNumberString
    }

    // TODO: Docstring
    var dayNumbersAndDatesText: String {
        return "\(self.dayNumbersText) - (\(self.currentDayString)):"
    }

    var taskViewModels: [EAGoalTaskViewModel] {
        return dayGuide.tasks.compactMap({
            DefaultEAGoalTaskViewModel(task: $0, tintColor: self.labelColor, goalsService: self.goalsService)
        })
    }

    let labelColor: UIColor

    init(dayGuide: EAGoalDayGuide, goalStartDate: Date, labelColor: UIColor, goalsService: EAGoalsService) {
        self.dayGuide = dayGuide
        self.goalStartDate = goalStartDate
        self.labelColor = labelColor
        self.goalsService = goalsService
    }
}

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

    /// A String that will be displayed representing the day(s) for this day guide (ex: Days 3 - 5)
    var daysText: String { get }

    /// A list of EAGoalTask representing the tasks for this day guide
    var taskViewModels: [EAGoalTaskViewModel] { get }

    /// The color for the goal
    var color: UIColor { get }
}

protocol EAGoalDayGuideViewModel: EAGoalDayGuideViewModelInput, EAGoalDayGuideViewModelOutput { }

/// ViewModel used to show information for day guides
final class DefaultEAGoalDayGuideViewModel: EAGoalDayGuideViewModel {

    /// The EAGoalDayGuide that this ViewModel represents
    private let dayGuide: EAGoalDayGuide

    /// A service to interact with goals and other related types
    private let goalsService: EAGoalsService

    var daysText: String {
        return dayGuide.days.count > 1 ? "Days \(dayGuide.days[0]) - \(dayGuide.days[1]):" : "Day \(dayGuide.days[0]):"
    }

    var taskViewModels: [EAGoalTaskViewModel] {
        return dayGuide.tasks.compactMap({
            DefaultEAGoalTaskViewModel(task: $0, textColor: self.color, goalsService: self.goalsService)
        })
    }

    let color: UIColor

    init(dayGuide: EAGoalDayGuide, color: UIColor, goalsService: EAGoalsService) {
        self.dayGuide = dayGuide
        self.color = color
        self.goalsService = goalsService
    }
}

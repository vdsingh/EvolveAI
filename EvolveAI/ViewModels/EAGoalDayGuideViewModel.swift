//
//  EADayGuideViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/13/23.
//

import Foundation
import RealmSwift

// TODO: Docstrings

protocol EAGoalDayGuideViewModelInput {

}

protocol EAGoalDayGuideViewModelOutput {
    var daysText: String { get }
    var taskViewModels: [EAGoalTaskViewModel] { get }
}

protocol EAGoalDayGuideViewModel: EAGoalDayGuideViewModelInput, EAGoalDayGuideViewModelOutput { }

/// ViewModel used to show information for day guides
final class DefaultEAGoalDayGuideViewModel: EAGoalDayGuideViewModel {

    private let dayGuide: EAGoalDayGuide
//    private var tasks: List<EAGoalTask>

    /// A String that will be displayed representing the day(s) for this day guide (ex: Days 3 - 5)
    // TODO: fix this
    var daysText: String {
        return dayGuide.days.count > 1 ? "Days \(dayGuide.days[0]) - \(dayGuide.days[1]):" : "Day \(dayGuide.days[0]):"
    }

    /// A list of EAGoalTask representing the tasks for this day guide
    var taskViewModels: [EAGoalTaskViewModel] {
        return dayGuide.tasks.compactMap({
            DefaultEAGoalTaskViewModel(task: $0, goalsService: EAGoalsService.shared)
        })
    }

    init(dayGuide: EAGoalDayGuide) {
        self.dayGuide = dayGuide
    }
}

extension DefaultEAGoalsListViewModel {

}

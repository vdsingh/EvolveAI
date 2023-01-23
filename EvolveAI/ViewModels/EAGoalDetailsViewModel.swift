//
//  EAGoalListItemViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/22/23.
//

import Foundation
import RealmSwift

/// Input functions
protocol EAGoalDetailsViewModelInput {

    /// The "delete" button was pressed
    func didPressDelete()
}

/// Properties that can be extracted from this ViewModel
protocol EAGoalDetailsViewModelOutput {
    /// The title of the goal
    var title: String { get }

    /// The number of days of the goal
    var numDays: Int { get }

    /// The goal color
    var colorHex: String { get }

    /// The day guides to display for the goal
    var dayGuideViewModels: [EAGoalDayGuideViewModel] { get }

    /// The additional details associated with the goal
    var additionalDetails: String { get }
}

protocol EAGoalDetailsViewModel: EAGoalDetailsViewModelInput, EAGoalDetailsViewModelOutput { }

/// ViewModel for the Goal Details View
final class DefaultEAGoalDetailsViewModel: EAGoalDetailsViewModel {

    /// Goals Service used to delete a goal.
    private let goalsService: EAGoalsService

    /// The goal that this ViewModel represents (reference is necessary for deletion)
    private var goal: EAGoal

    // MARK: - Output

    let title: String
    let numDays: Int
    let colorHex: String
    var dayGuideViewModels: [EAGoalDayGuideViewModel] {
        self.goal.dayGuides.compactMap({
            DefaultEAGoalDayGuideViewModel(dayGuide: $0)
        })
    }

    let additionalDetails: String

    /// Goal initializer
    /// - Parameter goal: The goal that this ViewModel represents
    init(goal: EAGoal, goalsService: EAGoalsService) {
        self.title = goal.goal
        self.numDays = goal.numDays
        self.colorHex = goal.colorHex
        self.additionalDetails = goal.additionalDetails
        self.goal = goal
        self.goalsService = goalsService
    }
}

// MARK: - Input
extension DefaultEAGoalDetailsViewModel {
    func didPressDelete() {
        self.goalsService.deletePersistedGoal(goal: self.goal)
    }
}

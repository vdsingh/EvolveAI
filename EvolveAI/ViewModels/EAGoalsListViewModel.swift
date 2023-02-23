//
//  EAGoalsListViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/21/23.
//

import Foundation
import RxSwift

/// Input methods for the ViewModel
protocol EAGoalsListViewModelInput {

    /// Callback for when a cell is selected
    /// - Parameter indexPath: The indexPath of the selected cell
    func didSelect(at indexPath: IndexPath)

    /// Callback for when the "add goal" button was clicked
    func addGoalButtonClicked()

    /// Fetches the EAGoal objects and updates the items array
    func fetchGoals()
}

/// Properties that can be extracted from the ViewModel
protocol EAGoalsListViewModelOutput {

    /// A list of EAGoalListItemViewModel objects
    var items: [EAGoalListItemViewModel] { get }
}

/// Actions handled by the ViewModel
struct EAGoalsListViewModelActions {

    /// Function for when we want to show the details screen for an EAGoal
    let showGoalDetails: (EAGoal) -> Void

    /// Function for when we want to show the goal creation form
    let showGoalCreationForm: () -> Void
}

protocol EAGoalsListViewModel: EAGoalsListViewModelInput, EAGoalsListViewModelOutput { }

final class DefaultEAGoalsListViewModel: EAGoalsListViewModel, Debuggable {
    let debug: Bool = true

    /// Service to interact with goals and other related types
    private let goalsService: EAGoalsService

    /// Actions that this ViewModel may need to execute
    private let actions: EAGoalsListViewModelActions

    // MARK: - Output

    var items: [EAGoalListItemViewModel] = []

    init(
        goalsService: EAGoalsService,
        actions: EAGoalsListViewModelActions
    ) {
        self.goalsService = goalsService
        self.actions = actions
    }
}

// MARK: - Input
extension DefaultEAGoalsListViewModel {

    /// Callback for when a cell is selected. Calls the showGoalDetails action.
    /// - Parameter indexPath: The indexPath of the selected cell
    func didSelect(at indexPath: IndexPath) {
        let listItemViewModel = items[indexPath.row]
        listItemViewModel.listItemWasTapped()
    }

    /// Callback for when the "add goal" button was clicked
    func addGoalButtonClicked() {
        self.actions.showGoalCreationForm()
    }

    /// Fetches the EAGoal objects and updates the items array
    func fetchGoals() {
        let goalListItemViewModels = self.goalsService.getAllPersistedGoals().compactMap { goal in
            var dayGuideViewModel: EAGoalDayGuideViewModel?
            if let todaysDayGuide = goal.todaysDayGuide {
                dayGuideViewModel = DefaultEAGoalDayGuideViewModel(
                    dayGuide: todaysDayGuide,
                    goalStartDate: goal.startDate,
                    labelColor: goal.color.darker() ?? .black,
                    goalsService: self.goalsService
                )
            }
            printDebug("DayGuideViewModel: \(String(describing: dayGuideViewModel))")
            return DefaultEAGoalListItemViewModel(
                goal: goal,
                dayGuideViewModel: dayGuideViewModel,
                actions: EAGoalListItemViewModelActions(
                    showGoalDetails: self.actions.showGoalDetails
                ),
                goalsService: self.goalsService
            )
        }

        let loadingListItemViewModels = self.goalsService.getAllLoadingGoals().compactMap {
            return DefaultEAGoalListItemViewModel(
                title: $0.title,
                numDays: $0.numDays,
                color: $0.color,
                actions: EAGoalListItemViewModelActions(
                    showGoalDetails: self.actions.showGoalDetails
                ),
                goalsService: self.goalsService
            )
        }

        self.items = []
        self.items.append(contentsOf: goalListItemViewModels)
        self.items.append(contentsOf: loadingListItemViewModels)

        printDebug("Fetched Goals: \(self.items.compactMap({ $0.title }))")
    }
}

extension DefaultEAGoalsListViewModel {
    func printDebug(_ message: String) {
        if self.debug {
            print("$Log: \(message)")
        }
    }
}

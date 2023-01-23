//
//  EAGoalsListViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/21/23.
//

import Foundation
import RxSwift

// TODO: Docstrings

/// Input methods for the ViewModel
protocol EAGoalsListViewModelInput {

    /// Callback for when a cell is selected
    /// - Parameter indexPath: The indexPath of the selected cell
    func didSelect(at indexPath: IndexPath)

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
}

protocol EAGoalsListViewModel: EAGoalsListViewModelInput, EAGoalsListViewModelOutput { }

final class DefaultEAGoalsListViewModel: EAGoalsListViewModel {

    private let goalsService: EAGoalsService
    private let actions: EAGoalsListViewModelActions

    private var goals: [EAGoal] = []

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

// MARK: - Input. View event methods
extension DefaultEAGoalsListViewModel {

    /// Callback for when a cell is selected. Calls the showGoalDetails action.
    /// - Parameter indexPath: The indexPath of the selected cell
    func didSelect(at indexPath: IndexPath) {
        let listItemViewModel = items[indexPath.row]
        listItemViewModel.wasTapped()
//        self.actions?.showGoalDetails(goals[indexPath.row])
    }

    /// Fetches the EAGoal objects and updates the items array
    func fetchGoals() {
        self.goals = self.goalsService.getAllPersistedGoals()
        self.items = self.goals.compactMap({
                return DefaultEAGoalListItemViewModel(
                    goal: $0,
                    actions: EAGoalListItemViewModelActions(showGoalDetails: self.actions.showGoalDetails)
                )
            }
        )
    }
}

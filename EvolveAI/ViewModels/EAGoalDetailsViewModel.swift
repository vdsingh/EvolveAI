//
//  EAGoalListItemViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/22/23.
//

import Foundation
import RealmSwift
import UIKit

/// Input functions
protocol EAGoalDetailsViewModelInput {

    /// The "delete" button was pressed
    func didPressDelete()
}

/// Properties that can be extracted from this ViewModel
protocol EAGoalDetailsViewModelOutput {
    /// The title of the goal
    var title: String { get }

    /// A String representing the number of days of the goal
    var numDaysString: String { get }

    /// A String representing the date when the goal was created (formatted)
    var dateCreatedString: String { get }

    /// An array of Strings representing the tags for the goal
    var tagStrings: [String] { get }

    /// The goal color
    var color: UIColor { get }

    /// The darker goal color
    var darkColor: UIColor { get }

    /// The day guides to display for the goal
    var dayGuideViewModels: [EAGoalDayGuideViewModel] { get }

    /// The additional details associated with the goal
    var additionalDetails: String { get }
    
    // MARK: - Developer Mode Variables
    
    //TODO: Docstring
    var modelUsedText: String { get }
    
    var aiResponse: String { get }
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
    var numDaysString: String {
        return "within \(goal.numDays) Days:"
    }

    var dateCreatedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: self.goal.creationDate)
        return "Created on: \(dateString)"
    }

    var tagStrings: [String]
    let color: UIColor
    var darkColor: UIColor {
        return self.color.darker() ?? .link
    }

    var dayGuideViewModels: [EAGoalDayGuideViewModel] {
        self.goal.dayGuides.compactMap({
            DefaultEAGoalDayGuideViewModel(dayGuide: $0, goalStartDate: self.goal.creationDate, labelColor: self.darkColor, goalsService: self.goalsService)
        })
    }

    let additionalDetails: String
        
    let modelUsedText: String
    
    let aiResponse: String

    /// Goal initializer
    /// - Parameter goal: The goal that this ViewModel represents
    /// - Parameter goalsService: Goals Service to interact with EAGoals and other related types
    init(goal: EAGoal, goalsService: EAGoalsService) {
        self.title = goal.goal
        self.color = goal.color
        self.additionalDetails = goal.additionalDetails
        self.modelUsedText = goal.modelUsed
        self.aiResponse = goal.aiResponse
        self.goal = goal
        self.goalsService = goalsService
        self.tagStrings = goal.tags.map({$0})
    }
}

// MARK: - Input
extension DefaultEAGoalDetailsViewModel {
    func didPressDelete() {
        self.goalsService.deletePersistedGoal(goal: self.goal)
    }
}

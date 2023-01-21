//
//  EACreateGoalQuestionViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation

/// A ViewModel used to create a Create Goal Question for forms.
struct EACreateGoalQuestionViewModel {

    /// The action text for the question
    let actionText: String

    /// The placeholder for the goal TextField
    let goalPlaceholderText: String

    /// Callback to use when goal text was edited
    let goalEditedCallback: (EATextField) -> Void

    /// Connector text for the second and third line
    let connectorText: String

    /// The placeholder text for the number of days TextField
    let numDaysPlaceholderText: String

    /// Callback to use when the num days text was edited
    let numDaysEditedCallback: (EATextField) -> Void

    /// The unit label for the number of days TextField
    let numDaysUnitLabel: String
}

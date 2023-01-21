//
//  Flags.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/14/23.
//

import Foundation

/// Used to toggle certain functionalities within the app
class Flags {

    /// Enable if you want to use Mock goals in EAGoalsService (they will be saved to Realm)
    static let useMockGoals = false

    /// Prints debug messages when creating tasks from AI response.
    static let printTaskMessages = false

    /// Prints messages associated with the API client.
    static let debugAPIClient = false

    /// Prints messages associated with the goals list
    static let debugGoalsList = false

    /// Prints messages associated with individual goals
    static let debugIndividualGoal = true

    /// Prints messages associated with the goal creation form
    static let debugGoalCreationForm = false
}

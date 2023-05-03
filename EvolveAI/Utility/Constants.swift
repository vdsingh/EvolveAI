//
//  Constants.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

/// Global, Easy Access Constants
struct Constants {

    /// The maximum amount of tokens allowed in response for a goal ($0.02 for 1000 tokens).
    static let maxTokens = 300

    /// The maximum number of goals a user can have
    static let maxGoalsAllowed = 5

    /// The maximum number of days the goal can be
    static let maxDays = 30

    /// Color to use for default theme
    static let defaultColor = UIColor.purple

    /// The default model to be used to generate goals
    static let defaultModel = EAGoalCreationModel.EAOpenAICompletionsModel(model: .davinci003)

    /// The default endpoint to be used to generate goals
    static let defaultEndpoint = EAGoalCreationEndpoint.EAOpenAIEndpoint(endpoint: .completions)
}

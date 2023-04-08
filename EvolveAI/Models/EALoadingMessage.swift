//
//  EALoadingMessage.swift
//  EvolveAI
//
//  Created by Vikram Singh on 4/7/23.
//

import Foundation

/// What the content of the message regards
enum EALoadingMessageTag {
    case fetchTags
    case fetchDayGuides
}

// TODO: Move, docstrings
class EALoadingMessage {
    let messageHistory: [EAOpenAIChatCompletionMessage]
    let messageTag: EALoadingMessageTag
    let goal: EAGoal

    let modelToUse: EAGoalCreationModel
    let endpointToUse: EAGoalCreationEndpoint

    init(
        messageHistory: [EAOpenAIChatCompletionMessage],
        messageTag: EALoadingMessageTag,
        goal: EAGoal,
        modelToUse: EAGoalCreationModel,
        endpointToUse: EAGoalCreationEndpoint
    ) {
        self.messageHistory = messageHistory
        self.messageTag = messageTag
        self.goal = goal
        self.modelToUse = modelToUse
        self.endpointToUse = endpointToUse
    }
}

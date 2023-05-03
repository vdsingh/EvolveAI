//
//  EAGoalCreationModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation

/// Protocol that any Goal Creation Models must follow
protocol EAGoalCreationModelProtocol {

    /// The token limit for a model
    var tokenLimit: Int { get }
}

/// Represents groupings of models that can be used for goal creations
enum EAGoalCreationModel {

    /// An OpenAI's Chat Completions Model
    case EAOpenAIChatCompletionsModel(model: EAOpenAIChatCompletionsModel)

    /// An OpenAI's Completions Model
    case EAOpenAICompletionsModel(model: EAOpenAICompletionsModel)

    /// Mock Model
    case EAMockingModel(model: EAMockingGoalCreationModel)

    case unknown

    /// The Raw Value for the model
    var rawVal: String {
        switch self {
        case .EAOpenAICompletionsModel(let model):
            return model.rawValue

        case .EAOpenAIChatCompletionsModel(let model):
            return model.rawValue

        case .EAMockingModel(let model):
            return model.rawValue

        case .unknown:
            return "unknown"
        }
    }
}

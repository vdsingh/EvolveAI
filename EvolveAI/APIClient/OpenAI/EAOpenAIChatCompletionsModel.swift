//
//  EAOpenAIChatCompletionsModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/2/23.
//

import Foundation
import RealmSwift

/// Represents groupings of models that can be used for goal creations
enum EAGoalCreationModel {

    /// An OpenAI's Chat Completions Model
    case EAOpenAIChatCompletionsModel(model: EAOpenAIChatCompletionsModel)

    /// An OpenAI's Completions Model
    case EAOpenAICompletionsModel(model: EAOpenAICompletionsModel)

    /// Mock Model
    case EAMockingModel(model: EAMockingGoalCreationModel)

    /// The Raw Value for the model
    var rawVal: String {
        switch self {
        case .EAOpenAICompletionsModel(let model):
            return model.rawValue

        case .EAOpenAIChatCompletionsModel(let model):
            return model.rawValue

        case .EAMockingModel(let model):
            return model.rawValue
        }
    }
}

/// Protocol that any Goal Creation Models must follow
protocol EAGoalCreationModelProtocol {

    /// The token limit for a model
    var tokenLimit: Int { get }
}

/// Mock Goal Creation Model
enum EAMockingGoalCreationModel: String {

    /// The goal creation was created by mocking
    case mocked

    /// The max number of tokens that a model can respond with
    var tokenLimit: Int {
        4000
    }
}

/// Open AI Chat Completions Models
enum EAOpenAIChatCompletionsModel: String, Codable, EAGoalCreationModelProtocol {

    /// Most capable GPT-3.5 model and optimized for chat at 1/10th the cost of text-davinci-003
    case gpt3_5Turbo = "gpt-3.5-turbo"

    /// The max number of tokens that a model can respond with
    var tokenLimit: Int {
        switch self {
        case .gpt3_5Turbo:
            return 4096
        }
    }
}

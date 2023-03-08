//
//  EAOpenAIChatCompletionsModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/2/23.
//

import Foundation
import RealmSwift

// TODO: Docstring
// protocol EAGoalCreationModel {
//    var tokenLimit: Int { get }
//
//    var rawVal: String { get }
// }

// TODO: Docstring
enum EAGoalCreationModel {
    case EAOpenAIChatCompletionsModel(model: EAOpenAIChatCompletionsModel)
    case EAOpenAICompletionsModel(model: EAOpenAICompletionsModel)
    case EAMockingModel(model: EAMockingModel)

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

// TODO: Docstring
protocol EAGoalCreationModelProtocol {
    var tokenLimit: Int { get }
}

// TODO: Docstring
enum EAMockingModel: String {

    case mocked

    var tokenLimit: Int {
        4000
    }
}

// extension EAOpenAIModel {
// TODO: Docstring
enum EAOpenAIChatCompletionsModel: String, Codable, EAGoalCreationModelProtocol {

    /// Most capable GPT-3.5 model and optimized for chat at 1/10th the cost of text-davinci-003
    case gpt3_5Turbo = "gpt-3.5-turbo"

    /// Gets the max number of tokens that a model can respond with
    /// - Returns: The number of tokens than a model can respond with
    var tokenLimit: Int {
        switch self {
        case .gpt3_5Turbo:
            return 4096
        }
    }
}

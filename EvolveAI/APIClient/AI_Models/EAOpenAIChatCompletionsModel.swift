//
//  EAOpenAIChatCompletionsModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/2/23.
//

import Foundation

/// Open AI Chat Completions Models
enum EAOpenAIChatCompletionsModel: String, Codable, EAGoalCreationModelProtocol {

    /// Most capable GPT-3.5 model and optimized for chat at 1/10th the cost of text-davinci-003
    case gpt3_5Turbo = "gpt-3.5-turbo-0301"

    /// The max number of tokens that a model can respond with
    var tokenLimit: Int {
        switch self {
        case .gpt3_5Turbo:
            return 4096
        }
    }
}

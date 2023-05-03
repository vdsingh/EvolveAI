//
//  EAOpenAICompletionsModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/2/23.
//

import Foundation

/// The possible models to be used for the OpenAI completions endpoint
enum EAOpenAICompletionsModel: String, Codable, EAGoalCreationModelProtocol {

    /// The davinci 003 model is the most sophisticated model
    case davinci003 = "text-davinci-003"

    /// The curie 001 model is very capable, but faster and lower cost than the davinci 003
    case curie001 = "text-curie-001"

    /// Capable of straightforward tasks, very fast, and lower cost.
    case babbage001 = "text-babbage-001"

    /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost
    case ada001 = "text-ada-001"

    /// Gets the max number of tokens that a model can respond with
    var tokenLimit: Int {
        switch self {
        case .davinci003:
            return 4000

        case .curie001, .babbage001, .ada001:
            return 2048
        }
    }
}

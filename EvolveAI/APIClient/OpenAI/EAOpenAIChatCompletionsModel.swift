//
//  EAOpenAIChatCompletionsModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/2/23.
//

import Foundation

// TODO: Docstring
enum EAOpenAIChatCompletionsModel: String, Codable {

    /// Most capable GPT-3.5 model and optimized for chat at 1/10th the cost of text-davinci-003
    case gpt3_5Turbo = "gpt-3.5-turbo"

    /// Gets the max number of tokens that a model can respond with
    /// - Returns: The number of tokens than a model can respond with
    public func getTokenLimit() -> Int {
        switch self {
        case .gpt3_5Turbo:
            return 4096
        }
    }
}

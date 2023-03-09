//
//  EAOpenAIChatCompletionsResponse.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation

//TODO: Docstring
struct EAOpenAIChatCompletionsResponse: EAGoalCreationAPIResponse {
    let id: String
    let object: String
    let created: Float
    let model: EAOpenAIChatCompletionsModel
    let usage: EAOpenAIResponseUsage
    private let choices: [EAOpenAIChatCompletionsChoice]
    
    func getChoices() -> [EAOpenAIChoice] {
        return choices
    }
}

//TODO: Docstring
struct EAOpenAIChatCompletionsChoice: Decodable, EAOpenAIChoice {
    let message: EAOpenAIChatCompletionMessage
    let finishReason: String
    let index: Int

    enum CodingKeys: String, CodingKey {
        case message
        case index
        case finishReason = "finish_reason"
    }
}

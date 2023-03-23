//
//  EAOpenAIChatCompletionsResponse.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation

/// Response from the OpenAI Chat Completions Endpoint
struct EAOpenAIChatCompletionsResponse: EAGoalCreationAPIResponse {

    /// id associated with response
    let id: String

    /// The object used to create the response
    let object: String

    /// The date created
    let created: Float

    /// The model used to process the request
    let model: EAOpenAIChatCompletionsModel

    /// Represents the number of tokens used for the whole process
    let usage: EAOpenAIResponseUsage

    /// The choices associated with the response
    private let choices: [EAOpenAIChatCompletionsChoice]

    /// Gets the choices associated with the response
    /// - Returns: The choices associated with the response
    func getChoices() -> [EAOpenAIChoice] {
        return choices
    }
}

/// Choice associated with Open AI Chat Completions response
struct EAOpenAIChatCompletionsChoice: Decodable, EAOpenAIChoice {

    /// The message associated with the choice
    let message: EAOpenAIChatCompletionMessage

    /// The reason why the message finished
    let finishReason: String

    /// The index from which to start
    let index: Int

    enum CodingKeys: String, CodingKey {
        case message
        case index
        case finishReason = "finish_reason"
    }
}

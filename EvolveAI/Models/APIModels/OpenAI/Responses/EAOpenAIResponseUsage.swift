//
//  EAOpenAICompletionsResponseUsage.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation

/// Represents the usage of an OpenAI Completions or Chat model
struct EAOpenAIResponseUsage: EAAPIResponse {

    /// The tokens used in the prompt
    let promptTokens: Int

    /// The tokens used in the response
    let completionTokens: Int

    /// The total tokens used
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

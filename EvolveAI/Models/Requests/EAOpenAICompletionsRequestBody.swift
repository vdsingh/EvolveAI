//
//  EAOpenAICompletionsRequestBody.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/2/23.
//

import Foundation
/// Object used to specify the request body for an OpenAI Completions Request
struct EAOpenAICompletionsRequestBody: Encodable, EARequestBody {
    /// The OpenAI completions model to be used
    let model: EAOpenAICompletionsModel
    /// The prompt to feed the AI
    let prompt: String
    /// What sampling temperature to use. Higher values means the model will take more risks
    let temperature: Int
    /// The maximum number of tokens to receive back (more tokens = more $)
    let max_tokens: Int
}

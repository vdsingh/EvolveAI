//
//  EAOpenAICompletionsResponseUsage.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation
struct EAOpenAIResponseUsage: EAAPIResponse {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

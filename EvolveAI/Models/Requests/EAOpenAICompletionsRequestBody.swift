//
//  EAOpenAICompletionsRequestBody.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/2/23.
//

import Foundation
struct EAOpenAICompletionsRequestBody: Encodable, EARequestBody {
    let model: EAOpenAICompletionsModel
    let prompt: String
    let temperature: Int
    let max_tokens: Int
}

//{"model": "text-davinci-003", "prompt": "Say this is a test", "temperature": 0, "max_tokens": 7}

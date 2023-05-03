//
//  EAOpenAIChatCompletionsRequestBody.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/2/23.
//

import RealmSwift

/// Object used to specify the request body for an OpenAI Chat Completions Request
struct EAOpenAIChatCompletionsRequestBody: Encodable, EARequestBody {

    /// The OpenAI chat completions model to be used
    let model: EAOpenAIChatCompletionsModel

    /// An array of the messages to send for the model to have context
    let messages: [EAOpenAIChatCompletionMessage]
}

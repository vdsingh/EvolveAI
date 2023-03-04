//
//  EAOpenAIChatCompletionsRequestBody.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/2/23.
//

import RealmSwift

/// Object used to specify the request body for an OpenAI Chat Completions Request
struct EAOpenAIChatCompletionsRequestBody: Encodable, EARequestBody {

    /// The OpenAI completions model to be used
    let model: EAOpenAIChatCompletionsModel

    // TODO: Docstring
    let messages: [EAOpenAIChatCompletionMessage]
}

// TODO: docstring
class EAOpenAIChatCompletionMessage: Object, Encodable {
    // TODO: docstring
    let role: EAOpenAIChatCompletionMessageRole

    // TODO: docstring
    let content: String

    init(role: EAOpenAIChatCompletionMessageRole, content: String) {
        self.role = role
        self.content = content
    }
}

// TODO: docstring
enum EAOpenAIChatCompletionMessageRole: String, Encodable {
    case system
    case user
    case assistant
}

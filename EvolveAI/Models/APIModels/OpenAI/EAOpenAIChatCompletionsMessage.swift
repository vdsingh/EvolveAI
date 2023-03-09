//
//  EAOpenAIChatCompletionsMessage.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation
import RealmSwift

/// Represents a message for Chat Completions (sent and received so it must be Codable)
class EAOpenAIChatCompletionMessage: Object, Codable {

    /// The role associated with the sender of the message
    @Persisted var role: EAOpenAIChatCompletionMessageRole.RawValue

    /// The content of the message
    @Persisted var content: String

    /// Normal Initializer
    /// - Parameters:
    ///   - role: The role associated with the sender of the message
    ///   - content: The content of the message
    convenience init(role: EAOpenAIChatCompletionMessageRole, content: String) {
        self.init()
        self.role = role.rawValue
        self.content = content
    }
}

//
//  dkd.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation

/// Represents roles for those involved in Chat (for Chat Completions)
enum EAOpenAIChatCompletionMessageRole: String, Codable {

    /// The app (AKA the system)
    case app = "system"

    /// The user using the app
    case user

    /// The AI (AKA the assistant)
    case ai = "assistant"
}

//
//  dkd.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation

/// Represents roles for those involved in Chat (for Chat Completions)
enum EAOpenAIChatCompletionMessageRole: String, Codable {
    
    //TODO: Docstring
    case app = "system"
    case user
    case ai = "assistant"
}

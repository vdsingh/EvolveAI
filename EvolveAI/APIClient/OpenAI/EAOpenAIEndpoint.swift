//
//  EAOpenAIEndpoint.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation

/// The OpenAI endpoints that can be used in this applications
enum EAOpenAIEndpoint: String, EAEndpoint {

    /// Text completions endpoint
    case completions
    
    // TODO: Docstring
    case chatCompletions = "chat/completions"
}

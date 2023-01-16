//
//  Constants.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation

/// Global, Easy Access Constants
struct Constants {
    
    /// The maximum amount of tokens allowed in response for a goal ($0.02 for 1000 tokens).
    static let maxTokens = 500
    
    /// The maximum number of goals a user can have
    static let maxGoalsAllowed = 5
    
    /// How we separate the AI response into individual tasks
    static let taskSeparatorCharacter = "&%"
    
    /// The maximum number of days the goal can be
    static let maxDays = 30
}

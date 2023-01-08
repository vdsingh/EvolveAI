//
//  EAGoalsService.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
/// API for goals data
class EAGoalsService {
    
    /// Creates a string to send to the OpenAI Completions endpoint
    /// - Parameters:
    ///   - goal: A description of the goal to accomplish (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal in (ex: 30)
    /// - Returns: A string to send to the OpenAI Completions endpoint
    private func createOpenAICompletionsRequestString(goal: String, numDays: Int, characterLimit: Int) -> String {
        return "I have the goal: \(goal). I want to complete it in \(numDays) days. Give me a day by day guide to achieve this goal with a strict limit of \(characterLimit) characters."
    }
}

//
//  EAGoal.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/2/23.
//

import Foundation

struct EAGoal {
    let goal: String
    let numDays: Int
    let aiResponse: String
    let tasks: [EAGoalDayGuide]
    
    init(goal: String, numDays: Int, apiResponse: EAOpenAICompletionsResponse) {
        self.goal = goal
        self.numDays = numDays
        self.aiResponse = apiResponse.choices.first?.text ?? ""
        
        self.tasks = EAGoal.createTasks(from: aiResponse)
    }
    
    /// Creates a list of task objects from a given AI Response
    /// - Parameter aiResponse: the response from the AI
    /// - Returns: a list of task objects
    private static func createTasks(from aiResponse: String) -> [EAGoalDayGuide] {

        
//        "\n\n1. Day 1: Purchase a quality beginner violin, shoulder rest, and bow.\n\n2. Day 2: Watch YouTube tutorials on proper set-up and care of the violin.\n\n3. Day 3: Begin stringing and tuning your violin.\n\n4. Day 4: Read a basic book on violin playing and notation (e.g., Alfred’s Basic Violin Method).\n\n5. Day 5: Work on basic technique and fingering ("
        
        
        return []
    }
    
    /// Creates a string to send to the OpenAI Completions endpoint
    /// - Parameters:
    ///   - goal: A description of the goal to accomplish (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal in (ex: 30)
    /// - Returns: A string to send to the OpenAI Completions endpoint
    public static func createOpenAICompletionsRequestString(goal: String, numDays: Int) -> String{
        return "I have the goal: \(goal). I want to complete it in \(numDays) days. Give me a day by day guide to achieve this goal."
    }
}

/// Represents the guide for a given day (or set of days)
struct EAGoalDayGuide {
    /// Whether the guide covers the span of multiple days (ex: 1st to 3rd) instead of single day (ex: 1st)
    let isMultipleDays: Bool
    /// The range of days the guide covers
    let days: ClosedRange<Int>
    /// The list of tasks associated with this guide
    let tasks: [String]
}

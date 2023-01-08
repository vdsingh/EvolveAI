//
//  EAGoalsService.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
/// API for goals data
class EAGoalsService {
    /// Shared instance of the goals service
    static let shared = EAGoalsService()
    /// Access to the Realm database
    let realm = try! Realm()
    
    /// Constants that are used in the goals service
    struct Constants {
        static let characterLimit = 300
        static let numDaysLimit = 30
    }
    
    /// Possible codes to be returned by the create goal function
    enum CreateGoalCode: Int {
        /// Goal was created successfully
        case success = 0
        /// Proposed number of days was higher than the limit
        case dayLimitExceeded = 1
        /// Some other error was encountered
        case error = 2
        
        /// Provides a description of the CreateGoalCode
        /// - Returns: a description of the CreateGoalCode
        func codeDescription() -> String {
            switch self {
            case .success:
                return "Success"
            case .dayLimitExceeded:
                return "Please choose a shorter number of days to achieve the goal. The limit is \(Constants.numDaysLimit)"
            case .error:
                return "Other error encountered"
            }
        }
    }
    
    /// Private initializer ensures that the shared instance is used
    private init() { }
    
    /// Creates a string to send to the OpenAI Completions endpoint
    /// - Parameters:
    ///   - goal: A description of the goal to accomplish (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal in (ex: 30)
    /// - Returns: A string to send to the OpenAI Completions endpoint
    private func createOpenAICompletionsRequestString(goal: String, numDays: Int, characterLimit: Int) -> String {
        return "I have the goal: \(goal). I want to complete it in \(numDays) days. Give me a day by day guide to achieve this goal with a strict limit of \(characterLimit) characters."
    }
}

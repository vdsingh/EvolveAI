//
//  Mocking.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import Foundation

/// This class is used to create Mock objects
class Mocking {
    
    private static let mockGoals: [String] = [
       "learn the violin",
       "read 3 books",
       "lose 10 pounds",
       "learn to cook",
   ]
    
    /// This function creates an array of mock goals
    /// - Parameter numGoals: The number of mock goals to generate
    /// - Returns: An array of mock goals
    public static func createMockGoals(numGoals: Int) -> [EAGoal] {
        var goals = [EAGoal]()
        for _ in 0..<numGoals {
            guard let randomGoal = mockGoals.randomElement() else {
                fatalError("$Error: no mock goals")
            }
            
            goals.append(createMockGoal(goalString: randomGoal, numDays: nil))
        }
        
        return goals
    }
    
    /// Creates one mock goal
    /// - Returns: A Mock EAGoal
    public static func createMockGoal(goalString: String?,
                                      numDays: Int?,
                                      additionalDetails: String = ""
    ) -> EAGoal {
        guard let randomGoal = mockGoals.randomElement() else {
            fatalError("$Error: no mock goals")
        }
        
        let goal = EAGoal(goal: goalString ?? randomGoal,
                          numDays: numDays ?? Int.random(in: 1...Constants.maxDays),
                          additionalDetails: additionalDetails,
                          aiResponse: self.createMockGoalAIResponse())
        return goal
    }
    
    /// Creates a mock goal AI Response (Lorem Ipsum text)
    /// - Returns: A String representing an AI Response
    public static func createMockGoalAIResponse() -> String {
        var aiResponse = ""
        let maxNumTasks = 3
        for i in 1...Constants.maxDays {
            aiResponse += "Day \(i): "
            let numTasks = Int.random(in: 1...maxNumTasks)
            for _ in 0..<numTasks {
                aiResponse += "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor\(Constants.taskSeparatorCharacter)."
            }
            aiResponse += "\n"
        }
        return aiResponse
    }
}

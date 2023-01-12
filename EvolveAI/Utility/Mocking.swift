//
//  Mocking.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import Foundation
class Mocking {
    /// This function creates an array of mock goals
    /// - Parameter numGoals: The number of mock goals to generate
    /// - Returns: An array of mock goals
    public static func createMockGoals(numGoals: Int) -> [EAGoal] {
        let mockGoalsMap: [String: String] = [
            "learn the violin": "Day 1: Buy a violin.",
            "read 3 books": "Day 1: Buy a book.",
            "lose 10 pounds": "Day 1: Create a diet plan.",
            "learn to cook": "Day 1: Buy kitchen supplies",
        ]
        
        var goals = [EAGoal]()
        for _ in 0..<numGoals {
            guard let randomGoal = mockGoalsMap.randomElement() else {
                fatalError("$Error: no mock goals")
            }
            let goal = EAGoal(goal: randomGoal.key,
                              numDays: Int.random(in: 1...30),
                              additionalDetails: "",
                              aiResponse: randomGoal.value)
            goals.append(goal)
        }
        
        return goals
    }
}

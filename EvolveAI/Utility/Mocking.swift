//
//  Mocking.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import Foundation
import UIKit

/// This class is used to create Mock objects
class Mocking {

    private static let mockGoals: [String: String] = [
        "learn the violin": "Practice Mozart for 30 minutes",
        "read more books": "Research books or authors that you might be interested in",
        "lose 10 pounds": "Create a Diet Plan for the next week",
        "learn to cook": "Buy ingredients for your chosen recipe",
        "learn to code": "Research the pillars of Object Oriented Programming",
        "watch less television": "Remove the batteries from your remote",
        "go to the gym": "Find an affordable gym within 15 minutes of you",
        "eat less sugar": "Throw away any candy in your pantry",
        "learn carpentry": "Find blueprints to construct a wooden chair",
        "start a business": "Register your organization as an LLC"
    ]

    /// This function creates an array of mock goals
    /// - Parameter numGoals: The number of mock goals to generate
    /// - Returns: An array of mock goals
    public static func createMockGoals(numGoals: Int) -> [EAGoal] {
        if numGoals > mockGoals.count {
            fatalError("$Error: more mock goals requested than available.")
        }

        var goals = [EAGoal]()
        for _ in 0..<numGoals {
            guard let randomGoal = mockGoals.randomElement() else {
                fatalError("$Error: no mock goals")
            }

            goals.append(createMockGoal(goalString: randomGoal.key, numDays: nil))
        }

        return goals
    }

    /// Creates one mock goal
    /// - Returns: A Mock EAGoal
    public static func createMockGoal(
        goalString: String?,
//        taskString: String?,
        numDays: Int?,
        additionalDetails: String = ""
    ) -> EAGoal {
        guard let randomGoal = mockGoals.randomElement() else {
            fatalError("$Error: no mock goals")
        }

        let goal = EAGoal(
            creationDate: Date(),
            startDate: Date(),
            id: UUID().uuidString,
            goal: goalString ?? randomGoal.key,
            numDays: numDays ?? Int.random(in: 5...Constants.maxDays),
            additionalDetails: additionalDetails,
            color: EAColor.goalColors.randomElement()?.uiColor ?? EAColor.pastelOrange.uiColor,
            aiResponse: self.createMockGoalAIResponse()
        )
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

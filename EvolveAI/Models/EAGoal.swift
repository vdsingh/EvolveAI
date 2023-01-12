//
//  EAGoal.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/2/23.
//

import Foundation
import RealmSwift

/// Represents user goals
class EAGoal: Object {
    
    /// The goal itself (ex: "learn the violin")
    @Persisted var goal: String
    
    /// The number of days to accomplish the goal (ex: 30)
    @Persisted var numDays: Int
    
    /// The user specified additional details for the goal
    @Persisted var additionalDetails: String
    
    /// The AI's response in normal String form
    @Persisted var aiResponse: String
    
    /// The tasks associated with completing the goal (derived from parsing aiResponse)
    @Persisted var tasks: List<EAGoalDayGuide>
    
    /// Initializer for EAGoal
    /// - Parameters:
    ///   - goal: The goal itself (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal (ex: 30)
    ///   - additionalDetails: The user specified additional details for the goal
    ///   - apiResponse: The OpenAI Completions Response
    convenience init(goal: String, numDays: Int, additionalDetails: String, apiResponse: EAOpenAICompletionsResponse) {
        self.init()
        self.goal = goal
        self.numDays = numDays
        self.additionalDetails = additionalDetails
        self.aiResponse = apiResponse.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "NO AI RESPONSE"
        self.tasks = EAGoal.createTasks(from: aiResponse)
    }
    
    convenience init(goal: String, numDays: Int, additionalDetails: String, aiResponse: String) {
        self.init()
        self.goal = goal
        self.numDays = numDays
        self.additionalDetails = additionalDetails
        self.aiResponse = aiResponse.trimmingCharacters(in: .whitespacesAndNewlines)
        self.tasks = EAGoal.createTasks(from: aiResponse)
    }
    
    /// Possible errors that can arise from parsing AI response to create task
    private enum CreateTaskError: Error {
        case invalidNumberOfComponents
        case failedToParseDays
        case failedToParseDay
    }
    
    /// Creates a list of task objects from a given AI Response
    /// - Parameter aiResponse: the response from the AI
    /// - Returns: a list of task objects
    private static func createTasks(from aiResponse: String) -> List<EAGoalDayGuide> {
        let lines = aiResponse.split(separator: "\n")
        let dayGuides = List<EAGoalDayGuide>()
        // One line represents one EAGoalDayGuide Object
        for line in lines {
            // Separate the line by ":" which separates the Day Number info from the other info
            let components = line.split(separator: ":")
            // There should always be two components: day number(s) and task info
            if components.count == 2 {
                // Separate the tasks into
                let tasks = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: ".")
                    .filter({$0 != ""})
                    .map({return $0.trimmingCharacters(in: .whitespacesAndNewlines)})
                let taskList = List<String>()
                taskList.append(objectsIn: tasks)
                
                // Trim whitespaces and then "Day " to just get the number(s)
                let dayRangeString = components[0]
                    .trimmingCharacters(in: .whitespaces)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "Day "))
                // If the string contains a dash, it is a range (Ex: 1-3 vs 1)
                if dayRangeString.contains("-") {
                    // Split on the "-" to get the days
                    let days = dayRangeString.split(separator: "-")
                    // Parse the day numbers to integers
                    if let firstDay = Int(days[0]), let lastDay = Int(days[1]) {
                        let dayList = List<Int>()
                        dayList.append(objectsIn: [firstDay, lastDay])
                        let dayGuide = EAGoalDayGuide(
                            isMultipleDays: true,
                            days: dayList,
                            tasks: taskList)
                        dayGuides.append(dayGuide)
                    } else {
                        print("$Error: \(String(describing: CreateTaskError.failedToParseDays))")
                    }
                } else {
                    if let day = Int(dayRangeString) {
                        let dayList = List<Int>()
                        dayList.append(objectsIn: [day])
                        let dayGuide = EAGoalDayGuide(
                            isMultipleDays: false,
                            days: dayList,
                            tasks: taskList)
                        dayGuides.append(dayGuide)
                    } else {
                        print("$Error: \(String(describing: CreateTaskError.failedToParseDay))")
                    }
                }
            } else {
                print("$Error: \(String(describing: CreateTaskError.invalidNumberOfComponents)): \(components)")
            }
        }
        return dayGuides
    }
}

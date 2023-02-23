//
//  EAGoal.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/2/23.
//

import Foundation
import RealmSwift
import UIKit

/// Represents user goals
class EAGoal: Object {

    /// Date when the goal was created
    @Persisted var creationDate: Date

    /// A list of tags associated with this goal
    @Persisted private var tagsList: List<String>

    /// Unique identifier for the goal
    @Persisted var id: String

    /// The goal itself (ex: "learn the violin")
    @Persisted var goal: String

    /// The number of days to accomplish the goal (ex: 30)
    @Persisted var numDays: Int

    /// The user specified additional details for the goal
    @Persisted var additionalDetails: String

    /// The AI's response in normal String form
    @Persisted var aiResponse: String

    /// The Hex value for this goal's color
    @Persisted private var colorHex: String

    /// The daily guides associated with completing the goal (derived from parsing aiResponse)
    @Persisted var dayGuides: List<EAGoalDayGuide>

    /// When the user wants to start the goal
    @Persisted var startDate: Date

    /// The UIColor for this goal (uses colorHex)
    public var color: UIColor {
        get { UIColor(hex: self.colorHex) ?? Constants.defaultColor }
        set { self.colorHex = newValue.hexStringFromColor() }
    }

    /// The tags associated with this goal
    public var tags: [String] {
        get { [String](tagsList) }
        set {
            let newList = List<String>()
            newList.append(objectsIn: newValue)
            self.tagsList = newList
        }
    }

    /// The EAGoalDayGuide for today (if there is one)
    public var todaysDayGuide: EAGoalDayGuide? {
        return self.dayGuides.first(where: { dayGuide in
            let dayGuideDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: dayGuide.dayGuideDate)
            let todayDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())

            return dayGuideDateComponents.year == todayDateComponents.year &&
            dayGuideDateComponents.month == todayDateComponents.month &&
            dayGuideDateComponents.day == todayDateComponents.day
        })
    }

    /// Super initializer
    private convenience init(
        creationDate: Date,
        startDate: Date,
        id: String,
        goal: String,
        numDays: Int,
        additionalDetails: String,
        color: UIColor
    ) {
        self.init()
        self.creationDate = creationDate
        self.startDate = startDate
        self.id = id
        self.tags = tags
        self.goal = goal
        self.numDays = numDays
        self.additionalDetails = additionalDetails
        self.color = color
    }

    /// Initializer for EAGoal
    /// - Parameters:
    ///   - creationDate: The creation date of the goal
    ///   - startDate: The start date of the goal
    ///   - goal: The goal itself (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal (ex: 30)
    ///   - additionalDetails: The user specified additional details for the goal
    ///   - color: The color associated with the goal
    ///   - apiResponse: The OpenAI Completions Response
    convenience init(
        creationDate: Date,
        startDate: Date,
        goal: String,
        numDays: Int,
        additionalDetails: String,
        color: UIColor,
        apiResponse: EAOpenAICompletionsResponse
    ) {
        self.init(creationDate: creationDate, startDate: startDate, id: apiResponse.id, goal: goal, numDays: numDays, additionalDetails: additionalDetails, color: color)
        self.aiResponse = apiResponse.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "NO AI RESPONSE"
        let parsedResponse = EAGoal.parseAIResponse(from: aiResponse, startDate: startDate)
        self.dayGuides = parsedResponse.dayGuides
        self.tags = parsedResponse.tags
    }

    /// Initiailzer for EAGoal
    /// - Parameters:
    ///   - creationDate: The creation date of the goal
    ///   - startDate: The start date of the goal
    ///   - id: Unique identifier for the goal
    ///   - goal: The goal itself (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal (ex: 30)
    ///   - additionalDetails: The user specified additional details for the goal
    ///   - color: The color associated with the goal
    ///   - aiResponse: The AI Response
    convenience init(
        creationDate: Date,
        startDate: Date,
        id: String,
        goal: String,
        numDays: Int,
        additionalDetails: String,
        color: UIColor,
        aiResponse: String
    ) {
        self.init(creationDate: creationDate, startDate: startDate, id: id, goal: goal, numDays: numDays, additionalDetails: additionalDetails, color: color)
        self.aiResponse = aiResponse.trimmingCharacters(in: .whitespacesAndNewlines)
        let parsedResponse = EAGoal.parseAIResponse(from: aiResponse, startDate: startDate)
        self.dayGuides = parsedResponse.dayGuides
        self.tags = parsedResponse.tags
    }

    /// Possible errors that can arise from parsing AI response to create task
    private enum CreateTaskError: Error {
        case invalidNumberOfComponents
        case failedToParseDays
        case failedToParseDay
    }

    /// Creates a list of task objects from a given AI Response
    /// - Parameter aiResponse: the response from the AI
    /// - Parameter startDate: the start date of the goal
    /// - Returns: a list of task objects
    private static func parseAIResponse(from aiResponse: String, startDate: Date) -> (dayGuides: List<EAGoalDayGuide>, tags: [String]) {
        let lines = aiResponse.split(separator: "\n").filter({ !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty})
        printDebug("Lines: \(lines)")
        let dayGuides = List<EAGoalDayGuide>()
        var tags: [String] = []
        // One line represents one EAGoalDayGuide Object

        for line in lines {
            if line.first == "[" {
                tags = line
                    .components(separatedBy: CharacterSet(charactersIn: ","))
                    .compactMap({$0.trimmingCharacters(in: CharacterSet(charactersIn: "[ ]"))})
                printDebug("Tags: \(tags)")
                continue
            }

            // Separate the line by ":" which separates the Day Number info from the other info
            guard let colonIndex = line.firstIndex(of: ":") else {
                print("$Error: no colon found when constructing EAGoalDayGuide. Line: \(line)")
                continue
            }

            let components = [
                String(line[..<colonIndex]),
                String(line[colonIndex...]).trimmingCharacters(in: CharacterSet(charactersIn: ": "))
            ]
            printDebug("Components are \(components)")

            // Separate the tasks into
            let taskStrings = components[1]
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: Constants.taskSeparatorCharacter)
                .map({ return $0.trimmingCharacters(in: CharacterSet(charactersIn: " \n.")) })
                .filter({!$0.isEmpty})
            printDebug("Tasks are \(taskStrings)")

            let taskList = List<EAGoalTask>()
            for string in taskStrings {
                let task = EAGoalTask(taskString: string, complete: false)
                taskList.append(task)
            }

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
                    printDebug("Multiple Days are \(dayList)")
                    let dayGuide = EAGoalDayGuide(
                        isMultipleDays: true,
                        days: dayList,
                        tasks: taskList,
                        goalStartDate: startDate
                    )
                    dayGuides.append(dayGuide)
                } else {
                    print("$Error: \(String(describing: CreateTaskError.failedToParseDays))")
                }
            } else {
                if let day = Int(dayRangeString) {
                    let dayList = List<Int>()
                    dayList.append(objectsIn: [day])
                    printDebug("Day is \(dayList)")
                    let dayGuide = EAGoalDayGuide(
                        isMultipleDays: false,
                        days: dayList,
                        tasks: taskList,
                        goalStartDate: startDate
                    )
                    dayGuides.append(dayGuide)
                } else {
                    print("$Error: \(String(describing: CreateTaskError.failedToParseDay))")
                }
            }
        }

        return (dayGuides, tags)
    }

    /// Prints messages depending on whether the required flag is enabled
    /// - Parameter message: The message to print
    static func printDebug(_ message: String) {
        if Flags.printTaskMessages {
            print("$Log: \(message)")
        }
    }

    /// Gets a simplified String description of this goal
    /// - Returns: A String describing this goal
    public func getSimplifiedDescription() -> String {
        return "EAGoal {goal=\(self.goal). numDays=\(self.numDays). additional details=\(self.additionalDetails). AI Response=\(self.aiResponse) }"
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

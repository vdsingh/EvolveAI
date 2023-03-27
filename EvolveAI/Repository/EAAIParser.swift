//
//  EAAIParser.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/27/23.
//

import Foundation
import RealmSwift

extension EAGoalsService {

    /// Creates a list of task objects from a given AI Response
    /// - Parameter aiResponse: the response from the AI
    /// - Parameter startDate: the start date of the goal
    /// - Returns: a list of task objects
    func parseAIResponse(from aiResponse: String, startDate: Date) -> (dayGuides: List<EAGoalDayGuide>, tags: [String]) {
        let lines = aiResponse.split(separator: "\n").filter({ !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty})
        let dayGuides = List<EAGoalDayGuide>()
        var tags: [String] = []

        // One line represents one EAGoalDayGuide Object
        for line in lines {
            if line.trimmingCharacters(in: .whitespacesAndNewlines).first == "[" {
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
//                    printDebug("Day is \(dayList)")
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
}

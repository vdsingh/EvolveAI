//
//  EALanguageModelPromptBuilder.swift
//  EvolveAI
//
//  Created by Vikram Singh on 4/7/23.
//

import Foundation

protocol EALanguageModelGoalPromptCoder: EALanguageModelGoalPromptEncoder & EALanguageModelGoalPromptDecoder {}

// TODO: Docstring
protocol EALanguageModelGoalPromptEncoder {
    func encodeTagRequestString(goalString: String) -> String
    func encodeDayGuidesRequestString(goal: String, dayRange: ClosedRange<Int>) -> String
}

protocol EALanguageModelGoalPromptDecoder {
    func decodeTagResponseString(_ tagsString: String) -> [String]
    func decodeDayGuidesResponseString(aiResponse: String, goalStartDate: Date) -> [EAGoalDayGuide]
}

extension EAGoalsService: EALanguageModelGoalPromptCoder {

    // TODO: Docstring
    struct EALanguageModelGoalPromptCoderConstants {

        /// How we separate the AI response into individual tasks
        static let taskSeparatorCharacter = "&%"

        // TODO: Docstring
        static let daySeparatorCharacter = "@@"
    }
}

// TODO: Docstring
extension EAGoalsService: EALanguageModelGoalPromptEncoder {

    // TODO: Docstring
    func encodeTagRequestString(goalString: String) -> String {
        return "Give me 3 tags that can be used to categorize the goal \"\(goalString)\" in the format: \"[tag1,tag2,tag3]"
    }

    /// Creates a string to send to the OpenAI Completions endpoint
    /// - Parameters:
    ///   - goal: A description of the goal to accomplish (ex: "learn the violin")
    ///   - dayRange: The days that we are requesting day guides for
    /// - Returns: A string to send to the OpenAI Completions endpoint
    func encodeDayGuidesRequestString(goal: String, dayRange: ClosedRange<Int>) -> String {
        let guideFormat = "Day [Day Number]: [paragraph of tasks separated by \"\(EALanguageModelGoalPromptCoderConstants.taskSeparatorCharacter)\"] [New Line for next day]"
        var prompt = ""
        prompt += "I have the goal: \(goal). Give me a guide for days \(dayRange.lowerBound) to \(dayRange.upperBound). The guide for each day should be formatted like this: \(guideFormat), I want the guide for each day to be separated by \"@@\""
        prompt += " Be sure that your response is within a limit of 1000 characters."
//        prompt += " \(Constants.maxTokens - goal.numTokens(separatedBy: CharacterSet(charactersIn: " "))) characters."
        return prompt
    }
}

extension EAGoalsService: EALanguageModelGoalPromptDecoder {

    // TODO: Docstring
    func decodeTagResponseString(_ tagsString: String) -> [String] {
        // Find the index of the opening and closing square brackets
        guard let openBracketIndex = tagsString.firstIndex(of: "["),
              let closeBracketIndex = tagsString.lastIndex(of: "]")
        else {
            // If the string doesn't contain square brackets, return an empty array
            let components = tagsString.components(separatedBy: CharacterSet(charactersIn: ","))
            print("$Error: tried to decode tag response string but no brackets were found. Defaulting to separation by comma. Output: \(components)")
            return components
        }

        // Get the substring between the square brackets
        let tagsSubstring = tagsString[tagsString.index(after: openBracketIndex)..<closeBracketIndex]

        // Split the substring into an array of tags
        let tagsArray = tagsSubstring.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        return tagsArray
    }

    // TODO: Docstring
    func decodeDayGuidesResponseString(aiResponse: String, goalStartDate: Date) -> [EAGoalDayGuide] {
        printDebug("Attempting to decode Day Guides Response String.")
        var dayGuides = [EAGoalDayGuide]()
        let dayComponents: [String] = aiResponse.components(separatedBy: EALanguageModelGoalPromptCoderConstants.daySeparatorCharacter)
        printDebug("Day components count: \(dayComponents.count)")
        for dayComponent in dayComponents {
            let trimmedDayComponent = dayComponent.trimmingCharacters(in: .whitespacesAndNewlines)
            let dayNumberAndTasks = trimmedDayComponent.components(separatedBy: ":")

            var dayNumber = 1
            if let dayNumberComponent = dayNumberAndTasks.first?.components(separatedBy: " ").last,
               let dayNumberUnwrapped = Int(dayNumberComponent) {
                dayNumber = dayNumberUnwrapped
            }

            let tasks = dayNumberAndTasks.last?.components(separatedBy: EALanguageModelGoalPromptCoderConstants.taskSeparatorCharacter)
            if tasks == nil {
                print("$Error: tasks is nil when decoding day guides response: \(aiResponse)")
            }

            // TODO: Fix hardcoded goalStartDate
            let goalDayGuide = EAGoalDayGuide(isMultipleDays: false, days: [dayNumber], tasks: tasks ?? [], goalStartDate: goalStartDate)
            dayGuides.append(goalDayGuide)
        }
        return dayGuides
    }
}

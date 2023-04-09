//
//  EALanguageModelPromptBuilder.swift
//  EvolveAI
//
//  Created by Vikram Singh on 4/7/23.
//

import Foundation

protocol EALanguageModelGoalPromptCoder: EALanguageModelGoalPromptEncoder & EALanguageModelGoalPromptDecoder {}

//TODO: Docstring
protocol EALanguageModelGoalPromptEncoder {
    func encodeTagRequestString(goalString: String) ->  String
    func encodeDayGuidesRequestString(goal: String, dayRange: ClosedRange<Int>) -> String
//    func createOpenAIChatCompletionsRequestStrings(goal: String, numDays: Int) -> [EAOpenAIChatCompletionMessage]
}

protocol EALanguageModelGoalPromptDecoder {
    func decodeTagResponseString(_ tagsString: String) ->  [String]
    func decodeDayGuidesResponseString(aiResponse: String) -> [EAGoalDayGuide]
//    func createOpenAIChatCompletionsRequestStrings(goal: String, numDays: Int) -> [EAOpenAIChatCompletionMessage]
}

//TODO: Docstring
extension EAGoalsService: EALanguageModelGoalPromptEncoder {
    
    //TODO: Docstring
    func encodeTagRequestString(goalString: String) ->  String {
        return "Give me 3 tags that can be used to categorize the goal \"\(goalString)\" in the format: \"[tag1,tag2,tag3]"
    }
    
    /// Creates a string to send to the OpenAI Completions endpoint
    /// - Parameters:
    ///   - goal: A description of the goal to accomplish (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal in (ex: 30)
    /// - Returns: A string to send to the OpenAI Completions endpoint
    func encodeDayGuidesRequestString(goal: String, dayRange: ClosedRange<Int>) -> String {
        let guideFormat = "Day [Day Number]: [paragraph of tasks separated by \"\(Constants.taskSeparatorCharacter)\"] [New Line for next day]"
        var prompt = ""
        prompt += "I have the goal: \(goal). Next, give me a guide for days \(dayRange.lowerBound) to \(dayRange.upperBound) in the form \(guideFormat)."
        prompt += " Be sure that your response is within a limit of 1000 characters."
//        prompt += " \(Constants.maxTokens - goal.numTokens(separatedBy: CharacterSet(charactersIn: " "))) characters."
        return prompt
    }

    // TODO: Docstring
//    func createOpenAIChatCompletionsRequestStrings(goal: String, numDays: Int) -> [EAOpenAIChatCompletionMessage] {
//        var requestStrings = [EAOpenAIChatCompletionMessage]()
//        let message = EAOpenAIChatCompletionMessage(
//            role: .user,
//            content: "I have the goal: \(goal). Give me 3 tags that can be used to categorize this goal."
//        )
//        requestStrings.append(message)
//        let guideFormat = "Day <Day Number>: <paragraph of tasks separated by \"\(Constants.taskSeparatorCharacter)\"> <New Line for next day>"
//        let nextMessage = EAOpenAIChatCompletionMessage(
//            role: .user,
//            content: "I want to complete it in exactly \(numDays) days. Give me a guide for each day in the format: \(guideFormat)."
//        )
//        requestStrings.append(nextMessage)
//        return requestStrings
//    }
}

extension EAGoalsService: EALanguageModelGoalPromptDecoder {
    
    //TODO: Docstring
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
    
    //TODO: Docstring
    func decodeDayGuidesResponseString(aiResponse: String) -> [EAGoalDayGuide] {
        //TODO: Implement
        return []
    }
}

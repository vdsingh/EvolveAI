//
//  EALanguageModelPromptBuilder.swift
//  EvolveAI
//
//  Created by Vikram Singh on 4/7/23.
//

import Foundation

//TODO: Docstring
class EALanguageModelPromptBuilder {
    
    //TODO: Docstring
    static let shared = EALanguageModelPromptBuilder()
    
    private init() { }
    
    //TODO: Docstring
    func createTagRequestString(goalString: String) ->  String {
        return "Give me 3 tags that can be used to categorize the goal \"\(goalString)\" in the format: \"[tag1,tag2,tag3]"
    }
    
    
    /// Creates a string to send to the OpenAI Completions endpoint
    /// - Parameters:
    ///   - goal: A description of the goal to accomplish (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal in (ex: 30)
    /// - Returns: A string to send to the OpenAI Completions endpoint
    func createOpenAICompletionsRequestString(goal: String, numDays: Int) -> String {
        let guideFormat = "Day [Day Number]: [paragraph of tasks separated by \"\(Constants.taskSeparatorCharacter)\"] [New Line for next day]"
        var prompt = "I have the goal: \(goal). Firstly, give me 3 that can be used to categorize this goal in the format: \"[tag1,tag2,tag3] *New Line\"."
        prompt += "I want to complete it in exactly \(numDays) days. Next, give me a guide for every day in the form \(guideFormat)."
        prompt += " It is important to provide a guide for every day within \(numDays) that follows the guide format!"

        prompt += " Also, make sure that your entire response, which includes \"Day\", the day number, and the colon, is within a limit of"
        prompt += " \(Constants.maxTokens - goal.numTokens(separatedBy: CharacterSet(charactersIn: " "))) characters."
        return prompt
    }

    // TODO: Docstring
    func createOpenAIChatCompletionsRequestStrings(goal: String, numDays: Int) -> [EAOpenAIChatCompletionMessage] {
        var requestStrings = [EAOpenAIChatCompletionMessage]()
        let message = EAOpenAIChatCompletionMessage(
            role: .user,
            content: "I have the goal: \(goal). Give me 3 tags that can be used to categorize this goal."
        )
        requestStrings.append(message)
        let guideFormat = "Day <Day Number>: <paragraph of tasks separated by \"\(Constants.taskSeparatorCharacter)\"> <New Line for next day>"
        let nextMessage = EAOpenAIChatCompletionMessage(
            role: .user,
            content: "I want to complete it in exactly \(numDays) days. Give me a guide for each day in the format: \(guideFormat)."
        )
        requestStrings.append(nextMessage)
        return requestStrings
    }
}

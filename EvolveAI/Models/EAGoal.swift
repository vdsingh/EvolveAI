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

    /// The Hex value for this goal's color (color should be accessed through `color` computed variable)
    @Persisted private var colorHex: String

    /// The daily guides associated with completing the goal (derived from parsing aiResponse)
    @Persisted var dayGuides: List<EAGoalDayGuide>

    /// When the user wants to start the goal
    @Persisted var startDate: Date

    /// The message history for this goal (if a ChatCompletions endpoint was used)
    @Persisted var messageHistory: List<EAOpenAIChatCompletionMessage>

    // MARK: - Goal Creation Info

    /// Date when the goal was created
    @Persisted var creationDate: Date

    /// The AI's response in normal String form
    @Persisted var aiResponse: String

    /// The endpoint used to generate this goal
    @Persisted var endpointUsed: String

    /// The model used to generate this goal
    @Persisted var modelUsed: String

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
            return Date().occursOnSameDate(as: dayGuide.dayGuideDate)
        })
    }

    /// Initializer for EAGoal
    /// - Parameters:
    ///   - creationDate: The creation date of the goal
    ///   - startDate: The start date of the goal
    ///   - id: The unique identifier for this goal
    ///   - goal: The goal itself (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal (ex: 30)
    ///   - additionalDetails: The user specified additional details for the goal
    ///   - color: The color associated with the goal
    ///   - aiResponse: The response from the AI
    ///   - modelUsed: The model used to generate this goal
    ///   - endpointUsed: The endpoint used to generate this goal
    convenience init(
        creationDate: Date,
        startDate: Date,
        id: String,
        goal: String,
        numDays: Int,
        additionalDetails: String,
        color: UIColor,
        aiResponse: String,
        modelUsed: EAGoalCreationModel,
        endpointUsed: EAGoalCreationEndpoint
    ) {
        self.init()
        self.creationDate = creationDate
        self.modelUsed = modelUsed.rawVal
        self.endpointUsed = endpointUsed.rawVal
        self.aiResponse = aiResponse
        self.startDate = startDate
        self.id = id
        self.goal = goal
        self.numDays = numDays
        self.additionalDetails = additionalDetails
        self.color = color
    }

    /// Initializer for EAGoal
    /// - Parameters:
    ///   - creationDate: The creation date of the goal
    ///   - startDate: The start date of the goal
    ///   - id: The unique identifier for this goal
    ///   - goal: The goal itself (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal (ex: 30)
    ///   - additionalDetails: The user specified additional details for the goal
    ///   - color: The color associated with the goal
    ///   - apiResponse: The OpenAI Completions Response
    ///   - modelUsed: The model used to generate this goal
    ///   - endpointUsed: The endpoint used to generate this goal
    convenience init(
        creationDate: Date,
        startDate: Date,
        id: String,
        goal: String,
        numDays: Int,
        additionalDetails: String,
        color: UIColor,
        apiResponse: EAOpenAICompletionsResponse,
        modelUsed: EAGoalCreationModel,
        endpointUsed: EAGoalCreationEndpoint
    ) {
        let aiResponse = apiResponse.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "NO AI RESPONSE"
        self.init(
            creationDate: creationDate,
            startDate: startDate,
            id: id,
            goal: goal,
            numDays: numDays,
            additionalDetails: additionalDetails,
            color: color,
            aiResponse: aiResponse,
            modelUsed: modelUsed,
            endpointUsed: endpointUsed
        )

        let parsedResponse = EAGoalsService.parseAIResponse(from: aiResponse, startDate: startDate)
        self.dayGuides = parsedResponse.dayGuides
        self.tags = parsedResponse.tags
    }

    /// Possible errors that can arise from parsing AI response to create task
    private enum CreateTaskError: Error {
        case invalidNumberOfComponents
        case failedToParseDays
        case failedToParseDay
    }

    /// Adds a message to this goal's message history
    /// - Parameter message: The message to add to the message history
    func addMessage(message: EAOpenAIChatCompletionMessage) {
        self.messageHistory.append(message)
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

//
//  EAGoalsService.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

class EALoadingMessage {
    let message: EAOpenAIChatCompletionMessage
    let goal: EAGoal
    init(message: EAOpenAIChatCompletionMessage, goal: EAGoal) {
        self.message = message
        self.goal = goal
    }
}

import Foundation
import RealmSwift
import UIKit

/// API for goals data (CRUD)
class EAGoalsService: Debuggable {
    
    let debug = true
    
    /// Access to the Realm database
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("$Error: Realm is nil.")
        }
    }

    /// Constants that are used in the goals service
    private struct GoalServiceConstants {
        static let characterLimit = 10
        static let numDaysLimit = 30
    }

    // TODO: Docstrings for cases
    /// Possible errors that can arise from parsing AI response to create task
    enum CreateTaskError: Error {
        case invalidNumberOfComponents
        case failedToParseDays
        case failedToParseDay
    }

    /// Possible errors to be returned by the create goal function
    enum CreateGoalError: Error {

        /// Proposed number of days was higher than the limit
        case dayLimitExceeded

        /// The user has already created the maximum allowed number of goals
        case maxGoalsExceeded

        /// The realm instance is nil
        case realmWasNil

        /// Some other error was encountered
        case unknownError(_ error: Error)

        /// Provides a description of the CreateGoalCode
        /// - Returns: a description of the CreateGoalCode
        func codeDescription() -> String {
            switch self {
            case .dayLimitExceeded:
                return "Please choose a shorter number of days to achieve the goal. The limit is \(GoalServiceConstants.numDaysLimit)"
            case .maxGoalsExceeded:
                return "You've already created the maximum allowed number of goals (\(Constants.maxGoalsAllowed))"
            case .realmWasNil:
                return "We had an issue saving your data. Please restart the app."
            case .unknownError:
                return "Unknown error occurred"
            }
        }
    }

    /// Prints a message if the correct flags are enabled or the debug boolean is enabled
    /// - Parameter message: The message to print
    func printDebug(_ message: String) {
        if self.debug || Flags.debugAPIClient {
            print("$Log: \(message)")
        }
    }

    /// Creates a string to send to the OpenAI Completions endpoint
    /// - Parameters:
    ///   - goal: A description of the goal to accomplish (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal in (ex: 30)
    /// - Returns: A string to send to the OpenAI Completions endpoint
    private func createOpenAICompletionsRequestString(goal: String, numDays: Int) -> String {
        let guideFormat = "Day [Day Number]: [paragraph of tasks separated by \"\(Constants.taskSeparatorCharacter)\"] [New Line for next day]"
        var prompt = "I have the goal: \(goal). Firstly, give me 3 that can be used to categorize this goal in the format: \"[tag1,tag2,tag3] *New Line\"."
        prompt += "I want to complete it in exactly \(numDays) days. Next, give me a guide for every day in the form \(guideFormat)."
        prompt += " It is important to provide a guide for every day within \(numDays) that follows the guide format!"

        prompt += " Also, make sure that your entire response, which includes \"Day\", the day number, and the colon, is within a limit of"
        prompt += " \(Constants.maxTokens - goal.numTokens(separatedBy: CharacterSet(charactersIn: " "))) characters."
        return prompt
    }

    // TODO: Docstring
    private func createOpenAIChatCompletionsRequestStrings(goal: String, numDays: Int) -> [EAOpenAIChatCompletionMessage] {
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

    /// Determines whether the user has the max number of allowed goals
    /// - Returns: A Bool representing whether the user has the max number of allowed goals
    public func maximumGoalsReached() -> Bool {
        return getAllPersistedGoals().count >= Constants.maxGoalsAllowed
    }


    /// Gets all of the persisted EAGoal objects from the Realm database
    /// - Returns: an array of EAGoal objects from the Realm database
    public func getAllPersistedGoals() -> [EAGoal] {
        var goals = [EAGoal]()
        if Flags.useMockGoals {
            goals = MockGoals.mockGoals
        } else {
            goals.append(contentsOf: realm.objects(EAGoal.self))
        }
        return goals
    }

    /// Dequeues loading goals and creates them
    /// - Parameter completion: Callback for when the loading goals have all been created
    private func processLoadingMessages(completion: @escaping (EAGoal) -> Void) {
        if self.loadingMessages.isEmpty {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            for _ in 0..<self.loadingMessages.count {
                if let loadingMessage = self.loadingMessages.last {
                    self.printDebug("Loading Message \(loadingMessage.message) was dequeued. Creating now.")
                    // TODO: Loading messages
//                    self.createGoal(
//                        loadingGoal: loadingGoal
//                    ) { [weak self] result in
//                        self?.loadingGoals.removeLast()
//                        switch result {
//                        case .success(let goal):
//                            self?.printDebug("Goal was successfully created: \(goal.goal)")
//                            completion(goal)
//
//                        case .failure(let error):
//                            print("$Error creating loading goal: \(error)")
//                        }
//                    }
                }
            }
        }
    }

    /// Updates a provided goal
    /// - Parameters:
    ///   - updateBlock: A function in which all desired updates are made to the goal
    public func updateGoal(updateBlock: () -> Void) {
        writeToRealm {
            updateBlock()
        }
    }

    /// Deletes a provided goal
    /// - Parameter goal: The goal to be deleted
    public func deletePersistedGoal(goal: EAGoal) {
        writeToRealm {
            realm.delete(goal)
        }
    }

    // MARK: - Tasks

    /// Sets a given task's completion status
    /// - Parameters:
    ///   - task: The task we are editing
    ///   - complete: Whether the task should be marked as complete or not
    public func toggleTaskCompletion(task: EAGoalTask, complete: Bool) {
        self.writeToRealm {
            task.complete = complete
        }
    }
}

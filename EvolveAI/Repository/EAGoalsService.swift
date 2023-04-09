//
//  EAGoalsService.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
import RealmSwift
import UIKit

/// API for goals data (CRUD)
class EAGoalsService: Debuggable {

    let debug = false

    /// Access to the Realm database
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("$Error: Realm is nil.")
        }
    }

    // TODO: Docstring
    private var loadingMessages = [EALoadingMessage]()

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

    // TODO: Docstring, rename EAGoalCreationModel to EAGoalGuideCreationModel, completion?
    func executeGoalDayGuidesRequest(
        loadingMessage: EALoadingMessage,
        dayRange: ClosedRange<Int>,
        completion: @escaping (Result<EAGoal, Error>) -> Void
    ) {
        if loadingMessage.messageTag != .fetchDayGuides {
            print("$Error: executing goal day guides request when the loading message messageTag was \(loadingMessage.messageTag)")
        }
        
        let languageModel = loadingMessage.modelToUse
        switch languageModel {
        case .EAOpenAIChatCompletionsModel(let chatCompletionsModel):
            // TODO: Implement
            return

        case .EAOpenAICompletionsModel(let completionsModel):
//            let message = self.createOpenAICompletionsRequestString(goal: loadingMessage.goal.goal, numDays: loadingMessage.goal.numDays)
//            let message = EALanguageModelPromptBuilder.shared.createOpenAICompletionsRequestString(goal: loadingMessage.goal.goal, numDays: loadingMessage.goal.numDays)
            let dayGuidesRequestMessage = self.encodeDayGuidesRequestString(goal: loadingMessage.goal.goal, dayRange: dayRange)
            printDebug("Will attempt to execute Goal Day Guides request with the message: \(dayGuidesRequestMessage)")
            let userMessage = EAOpenAIChatCompletionMessage(role: .user, content: dayGuidesRequestMessage)
            loadingMessage.goal.addMessageToHistory(message: userMessage)
            
            // Tell the goal that there are day guides currently loading
            let numDayGuidesRequested = dayRange.count
            loadingMessage.goal.numLoadingDayGuides += dayRange.count
            EAOpenAILanguageModelService.shared.executeCompletionsRequest(
                model: completionsModel,
                prompt: dayGuidesRequestMessage,
                completion: { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let aiResponse):
                            // Record the message history
                            let aiMessage = EAOpenAIChatCompletionMessage(role: .ai, content: aiResponse)
                            loadingMessage.goal.addMessageToHistory(message: aiMessage)
                            self?.printDebug("Successfully retrieved AI Response: \(aiResponse)")
                            
                            // Decode the AI Response to Day Guides
                            if let dayGuides = self?.decodeDayGuidesResponseString(aiResponse: aiResponse, goalStartDate: loadingMessage.goal.startDate) {
                                loadingMessage.goal.appendDayGuides(dayGuides)
                                loadingMessage.goal.numLoadingDayGuides -= dayGuides.count
                                if numDayGuidesRequested != dayGuides.count {
                                    print("$Error: the number of day guides requested does not equal the number received.")
                                }
                            } else {
                                print("$Error: unable to unwrap dayGuides.")
                            }
                            
                            self?.printDebug("Decoded Day Guides Response.")
                            
                            completion(.success(loadingMessage.goal))
                            
                        case .failure(let error):
                            completion(.failure(error))
                            print("$Error: \(error)")
                        }
                    }
                }
            )

            // TODO: Implement
        case .EAMockingModel(let mockingModel):
            // TODO: implement
            return

        case .unknown:
            print("$Error: attempting to execute goal guides request with unknown model")
            return
        }
    }

    /// Prints a message if the correct flags are enabled or the debug boolean is enabled
    /// - Parameter message: The message to print
    func printDebug(_ message: String) {
        if self.debug || Flags.debugAPIClient {
            print("$Log: \(message)")
        }
    }

    /// Determines whether the user has the max number of allowed goals
    /// - Returns: A Bool representing whether the user has the max number of allowed goals
    public func maximumGoalsReached() -> Bool {
        return getAllPersistedGoals().count >= Constants.maxGoalsAllowed
    }

    /// Gets all of the persisted EAGoal objects from the Realm database
    /// - Returns: an array of EAGoal objects from the Realm database
    public func getAllPersistedGoals() -> [EAGoal] {
        printDebug("Retrieving all persisted goals. from thread \(Thread.current)")
        var goals = [EAGoal]()
        if Flags.useMockGoals {
            goals = MockGoals.mockGoals
        } else {
            goals.append(contentsOf: self.realm.objects(EAGoal.self))
        }

        return goals
    }

    // TODO: Docstring
    public func addLoadingMessage(loadingMessage: EALoadingMessage, completion: @escaping (Result<EAGoal, Error>) -> Void) {
        self.loadingMessages.append(loadingMessage)
        self.processLoadingMessages(completion: completion)
    }

    /// Dequeues loading goals and creates them
    /// - Parameter completion: Callback for when the loading goals have all been created
    private func processLoadingMessages(completion: @escaping (Result<EAGoal, Error>) -> Void) {
        if self.loadingMessages.isEmpty {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            for _ in 0..<self.loadingMessages.count {
                if let loadingMessage = self.loadingMessages.last {
                    self.printDebug("Loading Message for goal \(loadingMessage.goal) was dequeued. Creating now.")
                    switch loadingMessage.messageTag {
                    case .fetchTags:
                        // TODO: Implement
                        return

                    case .fetchDayGuides:
                        self.executeGoalDayGuidesRequest(
                            loadingMessage: loadingMessage,
                            dayRange: 0...10,
                            completion: completion
                        )
                    }
                }
            }
        }
    }
    
    public func appendDayGuides(goal: EAGoal, dayGuides: [EAGoalDayGuide]) {
        self.writeToRealm {
            goal.dayGuides.append(objectsIn: dayGuides)
        }
    }

    // TODO: Docstring
    public func saveGoal(_ goal: EAGoal) {
        self.writeToRealm {
            self.realm.add(goal)
        }
    }

    /// Updates a provided goal
    /// - Parameters:
    ///   - updateBlock: A function in which all desired updates are made to the goal
    public func updateGoal(updateBlock: @escaping () -> Void) {
        self.writeToRealm {
            updateBlock()
        }
    }

    /// Deletes a provided goal
    /// - Parameter goal: The goal to be deleted
    public func deletePersistedGoal(goal: EAGoal) {
        let goalTitle = goal.goal
        self.printDebug("Attempting to delete goal \(goalTitle)")
        self.writeToRealm {
            self.realm.delete(goal)
            self.printDebug("deleted goal \(goalTitle)")
        }
    }

    /// Helper function to communicate with realm. Abstracts error handling.
    /// - Parameter action: The action that we want to accomplish (ex: realm.add(...))
    func writeToRealm(_ action: @escaping () -> Void) {
        DispatchQueue.main.async {
            do {
                self.printDebug("Write action from thread \(Thread.current)")
                try self.realm.write {
                    action()
                }
            } catch let error {
                print("$Error: \(String(describing: error))")
            }
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

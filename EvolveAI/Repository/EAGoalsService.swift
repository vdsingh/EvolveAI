//
//  EAGoalsService.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
import RealmSwift

/// API for goals data (CRUD)
class EAGoalsService {

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

    /// Creates a string to send to the OpenAI Completions endpoint
    /// - Parameters:
    ///   - goal: A description of the goal to accomplish (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal in (ex: 30)
    /// - Returns: A string to send to the OpenAI Completions endpoint
    private func createOpenAICompletionsRequestString(goal: String, numDays: Int) -> String {
        let guideFormat = "Day [Day Number]: [paragraph of tasks separated by \"\(Constants.taskSeparatorCharacter)\"] [New Line for next day]"
        var prompt = "I have the goal: \(goal). Firstly, give me between 3 and 5 tags that can be used to categorize this goal in the format: \"[tag1,tag2,tag3] *New Line\"."
        prompt += "I want to complete it in exactly \(numDays) days. Next, give me a guide for every day in the form \(guideFormat)."
        prompt += " It is important to provide a guide for every day within \(numDays) that follows the guide format!"

        prompt += " Also, make sure that your entire response, which includes \"Day\", the day number, and the colon, is within a limit of"
        prompt += " \(Constants.maxTokens - goal.numTokens(separatedBy: CharacterSet(charactersIn: " "))) characters."
        return prompt
    }

    /// Helper function to communicate with realm. Abstracts error handling.
    /// - Parameter action: The action that we want to accomplish (ex: realm.add(...))
    private func writeToRealm(_ action: () -> Void) {
        do {
            try self.realm.write {
                action()
            }
        } catch let error {
            print("$Error: \(String(describing: error))")
        }
    }

    /// Determines whether the user has the max number of allowed goals
    /// - Returns: A Bool representing whether the user has the max number of allowed goals
    public func maximumGoalsReached() -> Bool {
        return getAllPersistedGoals().count >= Constants.maxGoalsAllowed
    }

    /// Creates a goal and persists it to the Realm Database
    /// - Parameters:
    ///   - goal: The goal that user is trying to achieve (ex: "learn the violin")
    ///   - numDays: The number of days that the goal is to be achieved by (ex: 30 days)
    public func createGoal(
        goal: String,
        numDays: Int,
        additionalDetails: String,
        colorHex: String,
        completion: @escaping (Result<EAGoal, CreateGoalError>) -> Void
    ) {
        if Flags.useMockGoals {
            let goal = Mocking.createMockGoal(goalString: goal, numDays: numDays)
            DispatchQueue.main.async {
                self.writeToRealm {
                    self.realm.add(goal)
                }
                completion(.success(goal))
            }
            return
        }

        if getAllPersistedGoals().count > Constants.maxGoalsAllowed {
            completion(.failure(CreateGoalError.maxGoalsExceeded))
        }

        if numDays > GoalServiceConstants.numDaysLimit {
            completion(.failure(CreateGoalError.dayLimitExceeded))
        }

        let prompt = createOpenAICompletionsRequestString(
            goal: goal,
            numDays: numDays
        )
        let request = EAOpenAIRequest.completionsRequest(
            model: .davinci003,
            prompt: prompt,
            maxTokens: Constants.maxTokens
        )
        EARestAPIService.shared.execute(
            request,
            expecting: EAOpenAICompletionsResponse.self,
            completion: { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }

                switch result {
                case .success(let apiResponse):
                    let goal = EAGoal(
                        creationDate: Date(timeIntervalSince1970: TimeInterval(apiResponse.created)),
                        goal: goal,
                        numDays: numDays,
                        additionalDetails: additionalDetails,
                        colorHex: colorHex,
                        apiResponse: apiResponse
                    )
                    if Flags.debugAPIClient {
                        print("$Log: Goal: \(goal)")
                    }

                    DispatchQueue.main.async {
                        strongSelf.writeToRealm {
                            strongSelf.realm.add(goal)
                        }
                        completion(.success(goal))
                    }

                case .failure(let error):
                    completion(.failure(CreateGoalError.unknownError(error)))
                }
            }
        )
    }

    /// Gets all of the persisted EAGoal objects from the Realm database
    /// - Returns: an array of EAGoal objects from the Realm database
    public func getAllPersistedGoals() -> [EAGoal] {
        var goals = [EAGoal]()
        goals.append(contentsOf: realm.objects(EAGoal.self))
        return goals
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

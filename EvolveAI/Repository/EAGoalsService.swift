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
    
    /// Shared instance of the goals service
    static let shared = EAGoalsService()
    
    /// Access to the Realm database
    let realm = try! Realm()
    
    /// Constants that are used in the goals service
    private struct GoalServiceConstants {
        static let characterLimit = 10
        static let numDaysLimit = 30
    }
    
    /// Possible codes to be returned by the create goal function
    enum CreateGoalCode: Int {
        /// Goal was created successfully
        case success = 0
        /// Proposed number of days was higher than the limit
        case dayLimitExceeded = 1
        /// Some other error was encountered
        case error = 2
        
        /// Provides a description of the CreateGoalCode
        /// - Returns: a description of the CreateGoalCode
        func codeDescription() -> String {
            switch self {
            case .success:
                return "Success"
            case .dayLimitExceeded:
                return "Please choose a shorter number of days to achieve the goal. The limit is \(GoalServiceConstants.numDaysLimit)"
            case .error:
                return "Other error encountered"
            }
        }
    }
    
    /// Private initializer ensures that the shared instance is used
    private init() { }
    
    /// Creates a string to send to the OpenAI Completions endpoint
    /// - Parameters:
    ///   - goal: A description of the goal to accomplish (ex: "learn the violin")
    ///   - numDays: The number of days to accomplish the goal in (ex: 30)
    /// - Returns: A string to send to the OpenAI Completions endpoint
    private func createOpenAICompletionsRequestString(goal: String, numDays: Int) -> String {
        let guideFormat = "Day [Day Number]: [Paragraph of tasks in sentence form]"
        return "I have the goal: \(goal). I want to complete it in \(numDays) days. Give me a day by day guide in the form \(guideFormat) to achieve this goal with a strict limit of \(Constants.maxTokens) characters."
        
    }
    
    /// Creates a goal and persists it to the Realm Database
    /// - Parameters:
    ///   - goal: The goal that user is trying to achieve (ex: "learn the violin")
    ///   - numDays: The number of days that the goal is to be achieved by (ex: 30 days)
    public func createGoal(goal: String,
                           numDays: Int,
                           additionalDetails: String,
                           completion: @escaping (Result<EAGoal, Error>) -> Void) -> CreateGoalCode {
        
        if(numDays > GoalServiceConstants.numDaysLimit) {
            return .dayLimitExceeded
        }
        
        let prompt = createOpenAICompletionsRequestString(
            goal: goal,
            numDays: numDays)
        let request = EAOpenAIRequest.completionsRequest(prompt: prompt,
                                                         max_tokens: Constants.maxTokens)
        var code = CreateGoalCode.success
        EAService.shared.execute(
            request,
            expecting: EAOpenAICompletionsResponse.self,
            completion: { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let apiResponse):
                    let goal = EAGoal(goal: goal,
                                      numDays: numDays,
                                      additionalDetails: additionalDetails,
                                      apiResponse: apiResponse)
                    DispatchQueue.main.async {
                        strongSelf.writeToRealm {
                            strongSelf.realm.add(goal)
                        }
                        completion(.success(goal))
                    }
                    
                case .failure(let error):
                    print("$Error: \(String(describing: error))")
                    code = .error
                    return
                }
            }
        )
        return code
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
    
    /// Helper function to communicate with realm. Abstracts error handling.
    /// - Parameter action: The action that we want to accomplish (ex: realm.add(...))
    private func writeToRealm(_ action: () -> Void) {
        do {
            try realm.write {
                action()
            }
        } catch let error {
            print("$Error: \(String(describing: error))")
        }
    }
}

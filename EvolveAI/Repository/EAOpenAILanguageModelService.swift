//
//  EAOpenAIService.swift
//  EvolveAI
//
//  Created by Vikram Singh on 4/4/23.
//

import Foundation
import RealmSwift

class EAOpenAILanguageModelService: Debuggable {

    // TODO: Docstring
    let debug = false

    // TODO: Docstring
    enum EAOpenAILanguageModelServiceError: Error {
        case responseHadNoChoices
        case nilRequest
    }

    // TODO: Docstring
    static let shared = EAOpenAILanguageModelService()

    // TODO: Docstring
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("$Error: Realm is nil.")
        }
    }

    /// Creates a goal and persists it to the Realm Database
    /// - Parameters:
    ///   - goal: The goal that user is trying to achieve (ex: "learn the violin")
    ///   - numDays: The number of days that the goal is to be achieved by (ex: 30 days)
    func executeCompletionsRequest(
        model: EAOpenAICompletionsModel,
        prompt: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let request = EAOpenAIRequest.completionsRequest(
            model: model,
            prompt: prompt,
            maxTokens: model.tokenLimit
        ) else {
            print("$Error: Attempted to execute completions request but request was nil")
            completion(.failure(EAOpenAILanguageModelServiceError.nilRequest))
            return
        }

        EARestAPIService.shared.execute(
            request,
            expecting: EAOpenAICompletionsResponse.self,
            completion: { result in
                switch result {
                case .success(let aiCompletionsResponse):
                    if let first = aiCompletionsResponse.getChoices().first {
                        let aiResponse = first.getLastText()
                        completion(.success(aiResponse))
                    } else {
                        completion(.failure(EAOpenAILanguageModelServiceError.responseHadNoChoices))
                    }

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }

    // TODO: Docstring
    func printDebug(_ message: String) {
        if self.debug {
            print("$Log: \(message)")
        }
    }
}

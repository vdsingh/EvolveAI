//
//  EAOpenAICompletionsModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/2/23.
//

import Foundation
/// The possible models to be used for the OpenAI completions endpoint
enum EAOpenAICompletionsModel: String, Codable {
    /// The davinci003 is the most sophisticated model
    case davinci003 = "text-davinci-003"
}

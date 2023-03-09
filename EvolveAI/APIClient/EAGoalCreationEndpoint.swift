//
//  EAEndpoint.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import Foundation

/// Represents endpoints used in this application
enum EAGoalCreationEndpoint {

    /// Endpoint associated with OpenAI
    case EAOpenAIEndpoint(endpoint: EAOpenAIEndpoint)

    /// Mock endpoint
    case EAMockingEndpoint(endpoint: EAMockingEndpoint)

    /// The Raw Value of the endpoint
    var rawVal: String {
        switch self {
        case .EAOpenAIEndpoint(let endpoint):
            return endpoint.rawValue

        case .EAMockingEndpoint(let endpoint):
            return endpoint.rawValue
        }
    }
}

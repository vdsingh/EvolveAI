//
//  EAEndpoint.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import Foundation

/// Protocol that all endpoints must follow
// protocol EAEndpoint {
//    //TODO: Docstrings
//    var rawVal: String { get }
// }

enum EAEndpoint {
    case EAOpenAIEndpoint(endpoint: EAOpenAIEndpoint)
    case EAMockingEndpoint(endpoint: EAMockingEndpoint)

    var rawVal: String {
        switch self {
        case .EAOpenAIEndpoint(let endpoint):
            return endpoint.rawValue

        case .EAMockingEndpoint(let endpoint):
            return endpoint.rawValue
        }
    }
}

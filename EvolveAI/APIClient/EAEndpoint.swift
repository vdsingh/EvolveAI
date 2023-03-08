//
//  EAEndpoint.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import Foundation

//TODO: Docstring
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

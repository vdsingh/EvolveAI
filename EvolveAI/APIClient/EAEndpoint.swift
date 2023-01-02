//
//  EAEndpoint.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import Foundation
protocol EAEndpoint {
    
}

enum EAOpenAIEndpoint: String, EAEndpoint {
    case completions = "completions"
}

//
//  EAGoalCreationAPIResponse.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation
//TODO: Docstirng
protocol EAGoalCreationAPIResponse: EAAPIResponse {
    var id: String  { get }
    var object: String  { get }
    var created: Float  { get }
    
    func getChoices() -> [EAOpenAIChoice]
}

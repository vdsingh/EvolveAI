//
//  EAGoalCreationAPIResponse.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation

/// API Response models that are used for goal creation
protocol EAGoalCreationAPIResponse: EAAPIResponse {
    
    /// The response ID
    var id: String  { get }
    
    /// The response object (ex: 'chat.completion')
    var object: String  { get }
    
    /// Date created
    var created: Float  { get }
    
    /// Retrieves the choices array
    /// - Returns: The choices array
    func getChoices() -> [EAOpenAIChoice]
}

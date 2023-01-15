//
//  Flags.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/14/23.
//

import Foundation

/// Used to toggle certain functionalities within the app
class Flags {
    
    /// Prints any Goals that are received from EAGoalsService
    static let printGoalResponseOutput = false
    
    /// Prints the request body of requests that are sent
    static let printRequestBodyData = false
    
    /// Prints debug messages when creating tasks from AI response.
    static let printTaskMessages = true
    
    /// Prints messages associated with the API client.
    static let debugAPIClient = false
}

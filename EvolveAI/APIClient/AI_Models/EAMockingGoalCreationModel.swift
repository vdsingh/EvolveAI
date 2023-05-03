//
//  EAMockingGoalCreationModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 3/9/23.
//

import Foundation

/// Mock Goal Creation Model
enum EAMockingGoalCreationModel: String {

    /// The goal creation was created by mocking
    case mocked

    /// The max number of tokens that a model can respond with
    var tokenLimit: Int {
        4000
    }
}

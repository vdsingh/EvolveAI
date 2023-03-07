//
//  EALoadingGoal.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/5/23.
//

import Foundation
import UIKit

/// Model used to represent goals that are still loading
final class EALoadingGoal {

    /// The title of the goal itself
    var title: String

    /// The number of days for the goal
    var numDays: Int

    /// The goal's theme color
    var color: UIColor

    /// The Date that the user wants to start the goal
    var startDate: Date

    /// Additional Details associated with the goal
    var additionalDetails: String

    // TODO: Docstring
    var modelToUse: EAGoalCreationModel

    // TODO: Docstring
    var endpointToUse: EAEndpoint

    /// Normal initializer
    init(title: String, numDays: Int, color: UIColor, startDate: Date, additionalDetails: String, modelToUse: EAGoalCreationModel, endpointToUse: EAEndpoint) {
        self.title = title
        self.numDays = numDays
        self.color = color
        self.startDate = startDate
        self.additionalDetails = additionalDetails
        self.modelToUse = modelToUse
        self.endpointToUse = endpointToUse
    }
}

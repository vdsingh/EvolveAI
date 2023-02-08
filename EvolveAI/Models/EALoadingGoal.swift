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

    /// Additional Details associated with the goal
    var additionalDetails: String

    /// Normal initializer
    init(title: String, numDays: Int, color: UIColor, additionalDetails: String) {
        self.title = title
        self.numDays = numDays
        self.color = color
        self.additionalDetails = additionalDetails
    }
}

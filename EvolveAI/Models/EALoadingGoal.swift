//
//  EALoadingGoal.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/5/23.
//

import Foundation
import UIKit

// TODO: Docstring
final class EALoadingGoal {
    var title: String
    var numDays: Int
    var color: UIColor
    var additionalDetails: String

    init(title: String, numDays: Int, color: UIColor, additionalDetails: String) {
        self.title = title
        self.numDays = numDays
        self.color = color
        self.additionalDetails = additionalDetails
    }
}

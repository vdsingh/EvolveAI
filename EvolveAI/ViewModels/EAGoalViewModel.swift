//
//  EAGoalViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import Foundation
import RealmSwift
import UIKit

/// A ViewModel for EAGoals
struct EAGoalViewModel {
    
    /// The title of the goal
    public let title: String
    
    /// The number of days of the goal
    public let numDays: Int
    
    /// The goal color
    public let color: UIColor
    
    /// The day guides to display for the goal
    public let dayGuides: List<EAGoalDayGuide>
    
    /// The additional details associated with the goal
    public let additionalDetails: String
    
    init(
        title: String,
        numDays: Int,
        color: UIColor,
        dayGuides: List<EAGoalDayGuide>,
        additionalDetails: String
    ) {
        self.title = title
        self.numDays = numDays
        self.color = color
        self.dayGuides = dayGuides
        self.additionalDetails = additionalDetails
    }
}

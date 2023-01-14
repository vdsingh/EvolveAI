//
//  EAGoalViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import Foundation
import RealmSwift

/// A ViewModel for EAGoals
struct EAGoalViewModel {
    /// The title of the goal
    let title: String
    
    /// The number of days of the goal
    let numDays: Int
    
    /// The day guides to display for the goal
    let dayGuides: List<EAGoalDayGuide>
    
    /// The additional details associated with the goal
    let additionalDetails: String
}

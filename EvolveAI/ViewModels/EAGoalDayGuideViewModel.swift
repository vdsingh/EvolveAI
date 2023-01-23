//
//  EADayGuideViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/13/23.
//

import Foundation
import RealmSwift

/// ViewModel used to show information for day guides
struct EAGoalDayGuideViewModel {

    /// A String that will be displayed representing the day(s) for this day guide (ex: Days 3 - 5)
    let daysText: String

    /// A list of Strings representing the tasks for this day guide
    let tasksTexts: List<String>
}

//
//  EAGoalDayGuide.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/6/23.
//

import Foundation
/// Represents the guide for a given day (or set of days)
struct EAGoalDayGuide {
    /// Whether the guide covers the span of multiple days (ex: 1st to 3rd) instead of single day (ex: 1st)
    let isMultipleDays: Bool
    /// The range of days the guide covers
    let days: ClosedRange<Int>
    /// The list of tasks associated with this guide
    var tasks: [String]
}

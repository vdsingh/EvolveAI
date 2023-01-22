//
//  EAGoalsListViewModel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/21/23.
//

import Foundation
import RxSwift

class EAGoalsListViewModel {
    public var goals: PublishSubject<[EAGoal]> = PublishSubject()
    init() {
        let goals = EAGoalsService.shared.getAllPersistedGoals()
        self.goals.onNext(goals)
    }
}

//
//  ViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import UIKit
import RealmSwift

class EAGoalsViewController: UIViewController {

    var goals: [EAGoal]
    
    init(goals: [EAGoal]) {
        self.goals = goals
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func loadView() {
        let goalsView = EAGoalsView()
        goalsView.tableView.delegate = self
        goalsView.tableView.dataSource = self
        goals = EAGoalsService.shared.getAllPersistedGoals()
        view = goalsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func refreshView() {
        guard let view = view as? EAGoalsView else {
            fatalError("$Error: view is not EAGoalsView")
        }
        
        view.refreshView()
    }
}

extension EAGoalsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = goals[indexPath.row]
        let newVC = EAGoalViewController(goal: goal)
        show(newVC, sender: self)
    }
}

extension EAGoalsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: EAGoalTableViewCell.reuseIdentifier, for: indexPath) as? EAGoalTableViewCell {
            let goal = goals[indexPath.row]
            let goalViewModel = EAGoalViewModel(
                title: goal.goal,
                numDays: goal.numDays
            )
            cell.configure(with: goalViewModel)
            return cell
        }
        
        print("$Error: EAGoalTableViewCell couldn't be dequeued correctly.")
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

//
//  ViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import UIKit
import RealmSwift

class EAGoalsListViewController: UIViewController {

    var goals: [EAGoal]
    let navigator: GoalsListNavigator
    
    init(navigator: GoalsListNavigator, goals: [EAGoal]) {
        self.navigator = navigator
        self.goals = goals
        super.init(nibName: nil, bundle: nil)
        self.title = "Goals List"
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func loadView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addGoalButtonPressed)
        )
        let goalsView = EAGoalsView()
        goalsView.tableView.delegate = self
        goalsView.tableView.dataSource = self
        goals = EAGoalsService.shared.getAllPersistedGoals()
        view = goalsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc private func addGoalButtonPressed() {
        self.navigator.navigate(to: .createGoal(goalWasCreated: { [weak self] in
            self?.goals = EAGoalsService.shared.getAllPersistedGoals()
            self?.getView().refreshView()
        }))
    }
    
    private func getView() -> EAGoalsView {
        if let view = self.view as? EAGoalsView {
            return view
        } else {
            fatalError("$Error: Expected view to be type EAGoalsView but it wasn't")
        }
    }
}

extension EAGoalsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = goals[indexPath.row]
        navigator.navigate(to: .viewGoal(goal: goal))
    }
}

extension EAGoalsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: EAGoalTableViewCell.reuseIdentifier, for: indexPath) as? EAGoalTableViewCell {
            let goal = goals[indexPath.row]
            let goalViewModel = EAGoalViewModel(
                title: goal.goal,
                numDays: goal.numDays,
                guideText: goal.aiResponse
            )
            cell.configure(with: goalViewModel)
            return cell
        }
        
        print("$Error: EAGoalTableViewCell couldn't be dequeued correctly.")
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

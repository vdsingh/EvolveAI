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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(EAGoalsService.shared.maximumGoalsReached()) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "questionmark.circle"),
                style: .plain,
                target: self,
                action: #selector(self.questionButtonPressed)
            )
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(self.addGoalButtonPressed)
            )
        }
        
        self.goals = EAGoalsService.shared.getAllPersistedGoals()
        self.getView().refreshView()
    }
    
    override func loadView() {
        let goalsView = EAGoalsView()
        view = goalsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getView().setTableViewDelegate(self)
        self.getView().setTableViewDataSource(self)
    }
    
    /// Function called when the user clicks the question button (max goal limit reached)
    @objc private func questionButtonPressed() {
        let dialogMessage = UIAlertController(title: "Goal Limit Reached", message: "You've reached the maximum amount of goals.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            dialogMessage.dismiss(animated: true)
        })
        
        dialogMessage.addAction(okButton)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    /// Function called when the user clicks the add button to create a new goal
    @objc private func addGoalButtonPressed() {
        self.navigator.navigate(to: .createGoal(goalWasCreated: { [weak self] in
            self?.goals = EAGoalsService.shared.getAllPersistedGoals()
            self?.getView().refreshView()
        }))
    }
    
    /// Safely unwraps the view as an EAGoalsView and returns it (or invokes fatal)
    /// - Returns: The View as EAGoalsView
    private func getView() -> EAGoalsView {
        if let view = self.view as? EAGoalsView {
            return view
        } else {
            fatalError("$Error: Expected view to be type EAGoalsView but it wasn't")
        }
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

// MARK: - TableView Delegate
extension EAGoalsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = goals[indexPath.row]
        navigator.navigate(to: .viewGoal(goal: goal))
    }
}

// MARK: - TableView DataSource
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
                dayGuides: goal.dayGuides,
                additionalDetails: goal.additionalDetails
            )
            cell.configure(with: goalViewModel)
            return cell
        }
        
        print("$Error: EAGoalTableViewCell couldn't be dequeued correctly.")
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

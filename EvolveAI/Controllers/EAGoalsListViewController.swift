//
//  ViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import UIKit
import RealmSwift

class EAGoalsListViewController: UIViewController {

    /// The goals that we are viewing
    var viewModel: EAGoalsListViewModel {
        return DefaultEAGoalsListViewModel(
            goalsService: EAGoalsService.shared,
            actions: EAGoalsListViewModelActions(
                showGoalDetails: { [weak self] goal in
                    let goalDetailsViewModel = DefaultEAGoalDetailsViewModel(
                        goal: goal,
                        goalsService: EAGoalsService.shared
                    )
                    self?.navigator.navigate(to: .viewGoal(goalViewModel: goalDetailsViewModel))
                }
            )
        )
    }

    /// Navigator that dictates the flow
    let navigator: GoalsListNavigator

    /// Normal initializer
    /// - Parameters:
    ///   - navigator: The navigator which specifies the flow
    ///   - goals: The goals we are viewing
    init(navigator: GoalsListNavigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
        self.title = "Goals List"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if EAGoalsService.shared.maximumGoalsReached() {
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

        self.viewModel.fetchGoals()
        self.getView().refreshView()
    }

    override func loadView() {
        let goalsView = EAGoalsListView()
        view = goalsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getView().setCollectionViewDataSource(self)
        self.getView().setCollectionViewDelegate(self)
        printDebug("Set delegate and datasource.")
    }

    /// Function called when the user clicks the question button (max goal limit reached)
    @objc private func questionButtonPressed() {
        let dialogMessage = UIAlertController(title: "Goal Limit Reached", message: "You've reached the maximum amount of goals.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: { (_) -> Void in
            dialogMessage.dismiss(animated: true)
        })

        dialogMessage.addAction(okButton)
        self.present(dialogMessage, animated: true, completion: nil)
    }

    /// Function called when the user clicks the add button to create a new goal
    @objc private func addGoalButtonPressed() {
        self.navigator.navigate(to: .createGoal(goalWasCreated: { [weak self] in
            self?.printDebug("Goal was created from form. Refreshing goals data and view.")
            self?.viewModel.fetchGoals()
            self?.getView().refreshView()
        }))
    }

    /// Safely unwraps the view as an EAGoalsView and returns it (or invokes fatal)
    /// - Returns: The View as EAGoalsView
    private func getView() -> EAGoalsListView {
        if let view = self.view as? EAGoalsListView {
            return view
        } else {
            fatalError("$Error: Expected view to be type EAGoalsView but it wasn't")
        }
    }

    /// Prints a debug message if the necessary flags are true
    /// - Parameter message: the message to print
    private func printDebug(_ message: String) {
        if Flags.debugGoalsList {
            print("$Log: \(message)")
        }
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

extension EAGoalsListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        printDebug("Number of items: \(self.viewModel.items.count)")
        return self.viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EAGoalListItemCollectionViewCell.reuseIdentifier, for: indexPath) as? EAGoalListItemCollectionViewCell {
            let goalListItemViewModel = self.viewModel.items[indexPath.row]
            cell.configure(with: goalListItemViewModel)
            self.printDebug("returned cell and configured with \(goalListItemViewModel) at \(indexPath)")
            return cell
        }

        print("$Error: EAGoalTableViewCell couldn't be dequeued correctly.")
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
}

extension EAGoalsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.didSelect(at: indexPath)
    }
}

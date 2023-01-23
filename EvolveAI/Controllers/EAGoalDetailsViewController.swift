//
//  EAGoalViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

/// ViewController for screen for viewing a single goal's information
class EAGoalDetailsViewController: UIViewController {

    /// The EAGoal that we are focused on
    let goal: EAGoal
    
//    let viewModel = EAGoalViewModel(title: <#T##String#>, numDays: <#T##Int#>, color: <#T##UIColor#>, dayGuides: <#T##List<EAGoalDayGuide>#>, additionalDetails: <#T##String#>)

    /// Normal Initializer
    /// - Parameter goal: The goal that we are focused on
    init(goal: EAGoal) {
        self.goal = goal
        super.init(nibName: nil, bundle: nil)
        printDebug("Goal: \(goal)")
    }

    /// Loads the View
    override func loadView() {
        let viewModel = EAGoalViewModel(
            title: goal.goal,
            numDays: goal.numDays,
            color: goal.color,
            dayGuides: goal.dayGuides,
            additionalDetails: goal.additionalDetails
        )
        let goalView = EAGoalDetailsView(viewModel: viewModel)
        view = goalView
        self.title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.trashButtonPressed))
    }

    @objc private func trashButtonPressed() {
        let dialogMessage = UIAlertController(title: "Delete Goal", message: "Are you sure you want to delete this goal?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { (_) -> Void in
                dialogMessage.dismiss(animated: true)
            }
        )

        let deleteButton = UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { [weak self] (_) -> Void in
                dialogMessage.dismiss(animated: true)
                self?.deleteButtonPressed()
            }
        )

        dialogMessage.addAction(deleteButton)
        dialogMessage.addAction(cancelButton)
        self.present(dialogMessage, animated: true, completion: nil)
    }

    private func deleteButtonPressed() {
        EAGoalsService.shared.deletePersistedGoal(goal: self.goal)
        self.navigationController?.popToRootViewController(animated: true)
    }

    private func printDebug(_ message: String) {
        if Flags.debugIndividualGoal {
            print("$Log: \(message)")
        }
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

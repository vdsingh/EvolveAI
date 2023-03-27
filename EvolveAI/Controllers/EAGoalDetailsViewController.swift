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

    /// ViewModel for the Goal Details
    let viewModel: EAGoalDetailsViewModel

    /// Normal Initializer
    /// - Parameter goal: The goal that we are focused on
    init(viewModel: EAGoalDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        printDebug("ViewModel: \(viewModel)")
    }

    /// Loads the View
    override func loadView() {
        let goalView = EAGoalDetailsView(viewModel: viewModel)
        view = goalView
        self.title = viewModel.title

        let textAttributes = [NSAttributedString.Key.foregroundColor: viewModel.darkColor]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.trashButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = EAColor.failure.uiColor
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = viewModel.darkColor
        if let view = self.view as? EAGoalDetailsView {
            view.scrollToTodaysDayGuideView()
        } else {
            print("$Error: view for EAGoalDetailsViewController is not type EAGoalDetailsView.")
        }
    }

    /// Function called when trash can icon is pressed
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

    /// Function called when delete is pressed
    private func deleteButtonPressed() {
        self.viewModel.didPressDelete()
        self.navigationController?.popToRootViewController(animated: true)
    }

    /// Prints messages when the necessary flags are true
    /// - Parameter message: The message to print
    private func printDebug(_ message: String) {
        if Flags.debugIndividualGoal {
            print("$Log: \(message)")
        }
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

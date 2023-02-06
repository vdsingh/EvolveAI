//
//  EAGoalCreationFormViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

/// ViewController for screen for creating new goal (form)
class EAGoalCreationFormViewController: UIViewController, Debuggable {

    // TODO: Docstring
    let debug = true

    /// Constants for this screen
    struct GoalCreationConstants {

        /// The maximum amount of characters for the goal field
        static let maxGoalLength = 100
    }

    /// A String describing the goal (ex: "learn the violin"). nil if empty
    private var goal: String?

    /// An Int describing the number of days for the goal (ex: 10). nil if empty
    private var numDays: Int?

    /// A String describing additional details for the goal. Not used in generating the plan
    private var additionalDetails = ""

    /// A color for the goal
    private var color: UIColor = Constants.defaultColor

    /// A Button that the user will press when they have specified all necessary info and are finished. Reference is needed to enable/disable the button as necessary.
    private var createGoalButton: EAButton?

    // TODO: Docstring
    private let goalWillBeCreated: () -> Void

    /// Callback to use when the goal has been created
    private let goalWasCreated: () -> Void

    /// Service to interact with Goals (and other associated types)
    private let goalsService: EAGoalsService

    // TODO: Docstring
    /// Normal initializer
    /// - Parameter goalWasCreated: function to call when a goal was created using this form. Use to refresh UI elements.
    init(goalWillBeCreated: @escaping () -> Void, goalWasCreated: @escaping () -> Void, goalsService: EAGoalsService) {
        self.goalWillBeCreated = goalWillBeCreated
        self.goalWasCreated = goalWasCreated
        self.goalsService = goalsService
        super.init(nibName: nil, bundle: nil)
    }

    /// Load the view for the screen
    override func loadView() {
        self.title = "New Goal"
        let view = EAFormView(formElements: self.createFormElements())
        self.view = view
    }

    // MARK: - Private Functions

    /// Function that gets called when the "Create Goal Button" was pressed
    private func createGoalButtonPressed() {
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.updateButton()
        if let goal = self.goal, let numDays = self.numDays {
            DispatchQueue.main.async {
                let loadingGoal = EALoadingGoal(title: goal, numDays: numDays, color: self.color, additionalDetails: self.additionalDetails)
                self.goalsService.saveLoadingGoal(
                    loadingGoal,
                    goalWasAddedToQueue: {
                        self.printDebug("Calling goal was added to queue.")
                        self.goalWillBeCreated()
                    },
                    goalWasLoaded: { goal in
                        self.printDebug("Goal was loaded: \(goal.goal)")
                        self.goalWasCreated()
                    }
                )
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            fatalError("$Error: user was able to trigger createGoal with nil fields: Goal: \(String(describing: self.goal)), Num Days: \(String(describing: self.numDays)).")
        }
    }

    /// Handles any failures that occur with goal creation
    /// - Parameter error: The error that occurred when attempting to create the goal
    private func handleGoalCreationFailure(_ error: EAGoalsService.CreateGoalError) {
        switch error {
        case .maxGoalsExceeded:
            print("$Error: max goals exceeded: \(error.codeDescription())")

        case .dayLimitExceeded:
            print("$Error: day limit exceeded: \(error.codeDescription())")

        case .realmWasNil:
            print("$Error: realm was nil: \(error.codeDescription())")

        case .unknownError(let unknownError):
            print("$Error: unknown error: \(String(describing: unknownError))")
        }
    }

    /// Updates the status of the button based on whether the required fields are filled in correctly.
    private func updateButton() {
        if let buttonView = self.createGoalButton {
            guard let goal = self.goal,
                  self.numDays != nil,
                  !self.getView().isLoading(),
                  !goal.isEmpty
            else {
                buttonView.setEnabled(enabled: false)
                return
            }

            buttonView.setEnabled(enabled: true)
            buttonView.backgroundColor = self.color
        } else {
            fatalError("$Error: buttonView is not an EAButton type.")
        }
    }

    /// Casts a String to an Int
    /// - Parameter text: the Int within a String
    /// - Returns: an Int (if it can be casted)
    private func getNumber(text: String) -> Int? {
        if let numDays = Int(text),
           numDays > 0 {
            return numDays
        }

        return nil
    }

    /// Safely casts the view as an EAFormView (or creates a fatal error)
    /// - Returns: The ViewController's view as an EAFormView
    private func getView() -> EAFormView {
        if let view = self.view as? EAFormView {
            return view
        } else {
            fatalError("$Error: View is not of Type EAFormView.")
        }
    }

    /// Constructs the form elements for this screen
    /// - Returns: An array of EAFormElement objects
    private func createFormElements() -> [EAFormElement] {
        return [
            .goalCreationQuestion(
                actionText: "I am going to",
                goalPlaceholder: "learn the violin",
                connectorText: "within",
                goalTextWasEdited: { [weak self] textField in
                    guard let strongSelf = self else {
                        print("$Error: self is nil.")
                        return
                    }

                    strongSelf.printDebug("Goal Text Edited to: \(textField.text ?? "nil")")
                    if let goal = textField.text, !goal.isEmpty, goal.count < GoalCreationConstants.maxGoalLength {
                        strongSelf.goal = goal
                        textField.setBorderColor(color: .systemGreen)
                    } else {
                        strongSelf.goal = nil
                        textField.setBorderColor(color: .systemRed)
                    }

                    self?.updateButton()
                },
                numDaysPlaceholder: "Max: \(Constants.maxDays)",
                numDaysTextWasEdited: { [weak self] textField in
                    guard let strongSelf = self else {
                        print("$Error: self is nil.")
                        return
                    }

                    strongSelf.printDebug("NumDays Text Edited to: \(textField.text ?? "nil")")
                    if let text = textField.text,
                       let numDays = strongSelf.getNumber(text: text),
                       numDays <= Constants.maxDays {
                        strongSelf.numDays = numDays
                        textField.setBorderColor(color: .systemGreen)
                    } else {
                        strongSelf.numDays = nil
                        textField.setBorderColor(color: .systemRed)
                    }

                    strongSelf.updateButton()
                },
                numDaysLabel: "days."
            ),
            .separator,
            .colorSelector(
                colors: UIColor.eaColors,
                colorWasSelected: { [weak self] color in
                    self?.color = color
                    self?.updateButton()
                }
            ),
            .separator,
            .textViewQuestion(
                question: "Additional Details",
                textViewWasEdited: { [weak self] textView in
                    self?.additionalDetails = textView.text
                    self?.printDebug("Additional Details Text Edited to: \(textView.text ?? "nil")")
                }
            ),
            .button(
                buttonText: "Create Goal",
                enabledOnStart: false,
                viewSetter: { [weak self] button in
                    self?.createGoalButton = button
                },
                buttonPressed: { [weak self] _ in
                    self?.printDebug("Create Goal Button was pressed.")
                    self?.createGoalButtonPressed()
                }
            )
        ]
    }

    /// Prints a debug message if the necessary flags are true
    /// - Parameter message: The message to print
    func printDebug(_ message: String) {
        if Flags.debugGoalCreationForm || self.debug {
            print("$Log: \(message)")
        }
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

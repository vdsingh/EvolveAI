//
//  EAGoalCreationFormViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

/// ViewController for screen for creating new goal (form)
class EAGoalCreationFormViewController: UIViewController {
    
    /// Constants for this screen
    struct GoalCreationConstants {
        /// The maximum amount of characters for the goal field
        static let maxGoalLength = 50
        
        /// The maximum number of days the goal can be
        static let maxDays = 30
    }
    
    /// A String describing the goal (ex: "learn the violin"). nil if empty
    private var goal: String?
    
    /// An Int describing the number of days for the goal (ex: 10). nil if empty
    private var numDays: Int?
    
    /// A String describing additional details for the goal. Not used in generating the plan
    private var additionalDetails = ""
    
    /// A Button that the user will press when they have specified all necessary info and are finished
    private var createGoalButton: EAButton?
    
    /// Callback to use when the goal has been created
    private var goalWasCreated: () -> Void
    
    /// Normal initializer
    /// - Parameter goalWasCreated: function to call when a goal was created using this form. Use to refresh UI elements.
    init(goalWasCreated: @escaping () -> Void) {
        self.goalWasCreated = goalWasCreated
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Load the view for the screen
    override func loadView() {
        self.title = "New Goal"
        let view = EAFormView(formElements: [
            .goalCreationQuestion(
                actionText: "I am going to",
                goalPlaceholder: "learn the violin",
                connectorText: "within",
                goalTextWasEdited: { [weak self] textField in
                    guard let strongSelf = self else {
                        print("$Error: self is nil.")
                        return
                    }
                    
                    if let goal = textField.text, goal != "", goal.count < GoalCreationConstants.maxGoalLength {
                        strongSelf.goal = goal
                        textField.setBorderColor(color: .label)
                    } else {
                        strongSelf.goal = nil
                        textField.setBorderColor(color: .red)
                    }
                    
                    self?.updateButton()
                },
                numDaysPlaceholder: "30",
                numDaysTextWasEdited: { [weak self] textField in
                    guard let strongSelf = self else {
                        print("$Error: self is nil.")
                        return
                    }
                    
                    if let text = textField.text, let numDays = strongSelf.getNumber(text: text),
                       numDays <= GoalCreationConstants.maxDays {
                        strongSelf.numDays = numDays
                        textField.setBorderColor(color: .label)
                    } else {
                        strongSelf.numDays = nil
                        textField.setBorderColor(color: .red)
                    }
                    
                    strongSelf.updateButton()
                },
                numDaysLabel: "days."
            ),
            .separator,
            .textViewQuestion(question: "Additional Details", textViewWasEdited: { [weak self] textView in
                self?.additionalDetails = textView.text
            }),
            .button(
                buttonText: "Create Goal",
                enabledOnStart: false,
                viewSetter: { [weak self] button in
                    self?.createGoalButton = button
                },
                buttonPressed: { [weak self] in
                    print("Create Goal Button was pressed.")
                    self?.createGoalButtonPressed()
                }
            )
        ])
        
        self.view = view
    }
    
    /// Function that gets called when the "Create Goal Button" was pressed
    private func createGoalButtonPressed() {
        self.getView().setSpinner(isActive: true)
        if let goal = self.goal, let numDays = self.numDays {
            print("Num days: \(numDays)")
            let _ = EAGoalsService.shared.createGoal(
                goal: goal,
                numDays: numDays,
                additionalDetails: self.additionalDetails
            ) { [weak self] result in
                print("Create Goal Completion called.")
                self?.goalWasCreated()
                self?.getView().setSpinner(isActive: false)
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            fatalError("$Error: user was able to trigger createGoal with nil fields.")
        }
    }
    
    /// Updates the status of the button based on whether the required fields are filled in correctly.
    private func updateButton() {
        if let buttonView = self.createGoalButton {
            guard let goal = self.goal,
                  self.numDays != nil,
                    goal != ""
            else {
                buttonView.setEnabled(enabled: false)
                return
            }
            
            buttonView.setEnabled(enabled: true)
        } else {
            fatalError("$Error: buttonView is not an EAButton type.")
        }
    }
    
    /// Casts a String to an Int
    /// - Parameter text: the Int within a String
    /// - Returns: an Int (if it can be casted)
    private func getNumber(text: String) -> Int? {
        if let numDays = Int(text) {
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
    
    required init?(coder: NSCoder) {
        return nil
    }
}

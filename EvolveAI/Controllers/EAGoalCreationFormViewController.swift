//
//  EAGoalCreationFormViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit

class EAGoalCreationFormViewController: UIViewController {
    struct GoalCreationConstants {
        static let maxGoalLength = 50
        static let maxDays = 30
    }
    
    private var goal: String?
    private var numDays: Int?
    private var additionalDetails = ""
    private var createGoalButton: EAButton?
    private var goalWasCreated: () -> Void
    
    init(goalWasCreated: @escaping () -> Void) {
        self.goalWasCreated = goalWasCreated
        super.init(nibName: nil, bundle: nil)
    }
    
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
                    self?.createGoal()
                }
            )
        ])
        
        self.view = view
    }
    
    private func createGoal() {
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
    
    private func getNumber(text: String) -> Int? {
        if let numDays = Int(text) {
            return numDays
        }
        
        return nil
    }
    
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

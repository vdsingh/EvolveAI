//
//  EADayGuideView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/13/23.
//

import UIKit
import RealmSwift

/// View used to show details for a Day Guide within a specific goal
class EADayGuideView: UIStackView {

    /// Label which displays the
    let daysLabel: UILabel = {
        let daysLabel = UILabel()
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.font = .boldSystemFont(ofSize: EAIncrement.two.rawValue)
        return daysLabel
    }()

    /// StackView that holds the tasks associated with the Day Guide
    let tasksStackView: UIStackView = {
       let tasksStackView = UIStackView()
        tasksStackView.translatesAutoresizingMaskIntoConstraints = false
        tasksStackView.axis = .vertical
        tasksStackView.spacing = EAIncrement.one.rawValue / 2
        return tasksStackView
    }()

    /// Regular initializer
    /// - Parameter viewModel: EADayGuideViewModel to supply information for the View
    init(with viewModel: EADayGuideViewModel) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.daysLabel.text = viewModel.daysText
        self.addSubviewsAndEstablishConstraints(tasks: viewModel.tasksTexts)
    }

    // MARK: - Private Functions

    /// Adds the subviews of the View and activates the constraints
    /// - Parameter dayGuides: List of Strings representing Tasks that we need to add to our View
    private func addSubviewsAndEstablishConstraints(tasks: List<String>) {
        self.addArrangedSubview(daysLabel)
        self.addArrangedSubview(tasksStackView)
        self.addTasksToView(tasks: tasks)
    }

    /// Adds tasks information to the View
    /// - Parameter tasks: A list of Strings representing Tasks to add to the View
    private func addTasksToView(tasks: List<String>) {
        for index in 0..<tasks.count {
            let task = tasks[index]
            if Flags.printTaskMessages {
                print("$Log: Task: \(task)")
            }

            let stack = createTaskStack(taskNum: index+1, taskText: task)
            self.tasksStackView.addArrangedSubview(stack)
        }
    }

    /// Creates a horizontal StackView for a given task
    /// - Parameters:
    ///   - taskNum: The task number
    ///   - taskText: The text of the task
    /// - Returns: A UIStackView containing 2 UILabels: Number UILabel and Task UILabel
    private func createTaskStack(taskNum: Int, taskText: String) -> UIStackView {
        let taskLabel = UILabel(frame: .zero)
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.text = "\(taskText)"
        taskLabel.numberOfLines = 0

        // Shrink checkbox to make it appear the same size as text
        let checkbox = EACheckbox(size: EAIncrement.two.rawValue * 2/3)
        // Add padding above checkbox to make it inline with text
        let checkboxPadding = UIView()
        checkboxPadding.translatesAutoresizingMaskIntoConstraints = false
        let checkboxStack = UIStackView()
        checkboxStack.translatesAutoresizingMaskIntoConstraints = false
        checkboxStack.axis = .vertical
        checkboxStack.addArrangedSubview(checkboxPadding)
        checkboxStack.addArrangedSubview(checkbox)
        checkboxPadding.heightAnchor.constraint(equalToConstant: EAIncrement.one.rawValue / 3).isActive = true

        let taskStackView = UIStackView()
        taskStackView.translatesAutoresizingMaskIntoConstraints = false
        taskStackView.axis = .horizontal
        taskStackView.alignment = .top
        taskStackView.spacing = EAIncrement.one.rawValue
        taskStackView.addArrangedSubview(checkboxStack)
        taskStackView.addArrangedSubview(taskLabel)

        return taskStackView
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

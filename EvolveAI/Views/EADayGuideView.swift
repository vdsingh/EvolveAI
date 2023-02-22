//
//  EADayGuideView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/13/23.
//

import UIKit
import RealmSwift

/// View used to show details for a Day Guide within a specific goal
class EADayGuideView: UIStackView, EAUIElementView {

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
    init(with viewModel: EAGoalDayGuideViewModel) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = EAIncrement.one.rawValue
        self.daysLabel.text = viewModel.dayNumbersAndDatesText
        self.daysLabel.textColor = viewModel.labelColor

        self.addSubviewsAndEstablishConstraints(taskViewModels: viewModel.taskViewModels)
    }

    // MARK: - Private Functions

    /// Adds the subviews of the View and activates the constraints
    /// - Parameter dayGuides: List of Strings representing Tasks that we need to add to our View
    private func addSubviewsAndEstablishConstraints(taskViewModels: [EAGoalTaskViewModel]) {
        self.addArrangedSubview(daysLabel)
        self.addArrangedSubview(tasksStackView)
        self.addTasksToView(taskViewModels: taskViewModels)
    }

    /// Adds tasks information to the View
    /// - Parameter tasks: A list of Strings representing Tasks to add to the View
    private func addTasksToView(taskViewModels: [EAGoalTaskViewModel]) {
        for index in 0..<taskViewModels.count {
            let taskViewModel = taskViewModels[index]
            if Flags.printTaskMessages {
                print("$Log: Task: \(taskViewModel.text)")
            }

            let taskView = EAGoalTaskView(viewModel: taskViewModel, taskCompletionChangedCallback: nil)
            self.tasksStackView.addArrangedSubview(taskView)
        }
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

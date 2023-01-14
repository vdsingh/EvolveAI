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
    let taskStackView: UIStackView = {
       let taskStackView = UIStackView()
        taskStackView.translatesAutoresizingMaskIntoConstraints = false
        taskStackView.axis = .vertical
        return taskStackView
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
        self.addArrangedSubview(taskStackView)
        self.addTasksToView(tasks: tasks)
    }
    
    /// Adds tasks information to the View
    /// - Parameter tasks: A list of Strings representing Tasks to add to the View
    private func addTasksToView(tasks: List<String>) {
        for i in 0..<tasks.count {
            let task = tasks[i]
            let taskLabel = UILabel(frame: .zero)
            taskLabel.translatesAutoresizingMaskIntoConstraints = false
            taskLabel.numberOfLines = 0
            taskLabel.text = "(\(i + 1)) \(task)"
            self.taskStackView.addArrangedSubview(taskLabel)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

//
//  EADayGuideView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/13/23.
//

import UIKit
import RealmSwift

class EADayGuideView: UIStackView {
    let daysLabel: UILabel = {
        let daysLabel = UILabel()
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.font = .boldSystemFont(ofSize: EAIncrement.two.rawValue)
        return daysLabel
    }()
    
    let taskStackView: UIStackView = {
       let taskStackView = UIStackView()
        taskStackView.translatesAutoresizingMaskIntoConstraints = false
        taskStackView.axis = .vertical
        
        return taskStackView
    }()
    
    init(with viewModel: EADayGuideViewModel) {
        super.init(frame: .zero)
        self.axis = .vertical

        self.daysLabel.text = viewModel.daysText
        self.addSubviewsAndEstablishConstraints(tasks: viewModel.tasksTexts)
    }
    
    private func addSubviewsAndEstablishConstraints(tasks: List<String>) {
        self.addArrangedSubview(daysLabel)
        self.addArrangedSubview(taskStackView)
        self.addTasksToView(tasks: tasks)
    }
    
    private func addTasksToView(tasks: List<String>) {
        for i in 0..<tasks.count {
            let task = tasks[i]
            let taskLabel = UILabel(frame: .zero)
            taskLabel.translatesAutoresizingMaskIntoConstraints = false
            taskLabel.numberOfLines = 0
            taskLabel.text = "\(i + 1). \(task)"
            self.taskStackView.addArrangedSubview(taskLabel)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

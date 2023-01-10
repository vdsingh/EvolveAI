//
//  EAGoalsView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import UIKit

/// View to display EAGoal objects in a UITableView
class EAGoalsView: UIView {
    
    /// The UITableView in which the goals will be displayed
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EAGoalTableViewCell.self, forCellReuseIdentifier: EAGoalTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    /// Normal initializer
    init() {        
        super.init(frame: .zero)
        self.backgroundColor = .green
        
        addViewsAndEstablishConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    /// Adds the subviews and establishes constraints
    private func addViewsAndEstablishConstraints() {
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    /// Refreshes the view
    public func refreshView() {
        tableView.reloadData()
    }
}

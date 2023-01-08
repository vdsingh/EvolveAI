//
//  EAGoalsView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import UIKit

class EAGoalsView: UIView {
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EAGoalTableViewCell.self, forCellReuseIdentifier: EAGoalTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    init() {        
        super.init(frame: .zero)
        self.backgroundColor = .green
        
        addViewsAndEstablishConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addViewsAndEstablishConstraints() {
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    public func refreshView() {
        tableView.reloadData()
    }
}

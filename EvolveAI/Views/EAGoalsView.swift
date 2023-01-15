//
//  EAGoalsView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import UIKit

/// View to display EAGoal objects in a UITableView
class EAGoalsView: UIView {
    
    /// Constants for this View
    private struct Constants {
        static let emptyTableViewText = "You have no Goals yet. Create one using the \"+\" in the top right"
    }
    
    /// The UITableView in which the goals will be displayed
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EAGoalTableViewCell.self, forCellReuseIdentifier: EAGoalTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    /// Label to display when the TableView is empty
    private let emptyTableViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.emptyTableViewText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    /// Normal initializer
    init() {        
        super.init(frame: .zero)
        self.addViewsAndEstablishConstraints()
    }
    
    // MARK: - Private Functions
    
    /// Adds the subviews and establishes constraints
    private func addViewsAndEstablishConstraints() {
        self.addSubview(self.tableView)
        self.addSubview(self.emptyTableViewLabel)
        self.updateEmptyTableViewMessage()

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: rightAnchor),
            self.tableView.leftAnchor.constraint(equalTo: leftAnchor),
            
            self.emptyTableViewLabel.topAnchor.constraint(equalTo: topAnchor),
            self.emptyTableViewLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.emptyTableViewLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -EAIncrement.four.rawValue),
            self.emptyTableViewLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: EAIncrement.four.rawValue),
        ])
    }
    
    /// Hides/unhides the message for when the tableView is empty
    private func updateEmptyTableViewMessage() {
        self.emptyTableViewLabel.isHidden = self.tableView.numberOfRows(inSection: 0) == 0 ? false : true
    }
    
    // MARK: - Public Functions
    
    /// Refreshes the view
    public func refreshView() {
        tableView.reloadData()
        updateEmptyTableViewMessage()
    }
    
    public func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        self.tableView.delegate = delegate
    }
    
    public func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        self.tableView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

//
//  EAGoalsView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/7/23.
//

import UIKit

/// View to display EAGoal objects in a UITableView
class EAGoalsListView: UIView, Debuggable {
    let debug = false

    /// Constants for this View
    private struct Constants {
        /// The text for when there are no goals in the CollectionView
        static let emptyCollectionViewText = "You have no Goals yet. Create one using the \"+\" in the top right"
    }

    /// CollectionView used to display goals
    public let collectionView: UICollectionView = {
        let numItemsPerRow: CGFloat = 1
        let spacing: CGFloat = EAIncrement.two.rawValue

        let layout = EAGoalsListCollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(EAGoalListItemCollectionViewCell.self, forCellWithReuseIdentifier: EAGoalListItemCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = EAColor.background.uiColor
        return collectionView
    }()

    /// Label to display when the TableView is empty
    private let emptyTableViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.emptyCollectionViewText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = EAColor.secondaryLabel.uiColor
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
        self.addSubview(self.collectionView)
        self.addSubview(self.emptyTableViewLabel)
        self.updateEmptyTableViewMessage()

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),

            self.emptyTableViewLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.emptyTableViewLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.emptyTableViewLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -EAIncrement.four.rawValue),
            self.emptyTableViewLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: EAIncrement.four.rawValue)
        ])
    }

    /// Hides/unhides the message for when the tableView is empty
    private func updateEmptyTableViewMessage() {
        self.emptyTableViewLabel.isHidden = self.collectionView.numberOfItems(inSection: 0) == 0 ? false : true
    }

    // MARK: - Public Functions

    /// Refreshes the view
    public func refreshView() {
        printDebug("Refreshing GoalsListView")
        collectionView.reloadData()
        updateEmptyTableViewMessage()
    }

    /// Sets the delegate for the Goals CollectionView
    /// - Parameter delegate: The delegate that will handle the CollectionView
    public func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate) {
        self.collectionView.delegate = delegate
    }

    /// Sets the dataSource for the Goals CollectionView
    /// - Parameter dataSource: The dataSource for the CollectionView
    public func setCollectionViewDataSource(_ dataSource: UICollectionViewDataSource) {
        self.collectionView.dataSource = dataSource
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

extension EAGoalsListView {
    func printDebug(_ message: String) {
        if self.debug ||  Flags.debugGoalsList {
            print("$Log: \(message)")
        }
    }
}

// MARK: - Custom Layout

/// Custom FlowLayout for the Goals List CollectionView
class EAGoalsListCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        // By invalidating layout on bounds change, we avoid overlapping cells.
        return true
    }
}

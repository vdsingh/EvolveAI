//
//  EAGoalCollectionViewCell.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/14/23.
//

import UIKit

/// A UICollectionViewCell to hold EAGoal information
class EAGoalListItemCollectionViewCell: UICollectionViewCell, Debuggable {
    let debug: Bool = true

    /// Reuse identifier for the cell
    static let reuseIdentifier = "EAGoalCollectionViewCell"

    /// Displays the EAGoal title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: EAIncrement.one.rawValue * 1.5, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    /// Displays the EAGoal number of days
//    private let daysLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .white
//        label.textAlignment = .left
//        return label
//    }()
//
//    /// Displays the information text for the next task
//    private let nextTaskLabel: UILabel = {
//       let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .left
//        label.textColor = .white
//        return label
//    }()

    private let nextTaskView: EAGoalTaskView = {
        let nextTaskView = EAGoalTaskView()
        return nextTaskView
    }()

    /// Spinner for if the goal is loading
    private let spinner: EASpinner = {
        let spinner = EASpinner(backgroundColor: .systemGray)
        spinner.stopAnimating()
        return spinner
    }()

    // MARK: - Private Functions
    
    private func constructViews(with viewModel: EAGoalListItemViewModel) {

//    }
    
    /// Sets UI properties for this View
    /// - Parameter viewModel: The ViewModel which supplies the data
//    private func setUIProperties(viewModel: EAGoalListItemViewModel) {
        self.backgroundColor = viewModel.color
        self.layer.cornerRadius = EAIncrement.two.rawValue
        self.titleLabel.text = viewModel.title
//        self.daysLabel.text = "\(viewModel.numDays) days"
        if let nextTaskViewModel = viewModel.nextTaskViewModel {
//            self.nextTaskLabel.text = "Next Task (Day 2)"
            self.nextTaskView.configure(with: nextTaskViewModel)
            print("$Log: configuring next task: \(nextTaskViewModel.text)")
        } else {
            print("$Log: no detected next task for goal \(viewModel.title).")
        }

        if viewModel.loading {
            self.spinner.startAnimating()
        } else {
            self.spinner.stopAnimating()
        }
    }

    /// Adds subviews and establishes constraints for this view
    private func addSubviewsAndEstablishConstraints(viewModel: EAGoalListItemViewModel) {
        let mainStack: EAFormElement = .stack(axis: .vertical, spacing: .one, elements: [
            .label(text: viewModel.title, textStyle: EATextStyle.title),
            .label(text: "\(viewModel.numDays) days", textStyle: .heading1)
        ])
        let stackView = mainStack.createView()
        stackView.backgroundColor = .purple
        self.contentView.addSubview(stackView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let numItemsPerRow: CGFloat = 1
        let spacing: CGFloat = EAIncrement.two.rawValue
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = screenWidth / numItemsPerRow - (spacing * (numItemsPerRow + 1) / numItemsPerRow)
        // Add Spinner for when goal is loading
//        let goalInfoStackView = self.createStackView(with: [
//            self.titleLabel,
//            self.daysLabel
//        ])

//        let nextTaskStackView = self.createStackView(with: [
//            self.nextTaskLabel,
//            self.nextTaskView
//        ])

//        let mainStackView = self.createStackView(with: [
//            goalInfoStackView,
//            nextTaskStackView
//        ])
//        mainStackView.backgroundColor = .systemGray
//        self.contentView.addSubview(mainStackView)
        self.contentView.addSubview(self.spinner)

//        self.addSubview(mainStackView)
//        self.addSubview(self.spinner)

        NSLayoutConstraint.activate([
            self.contentView.widthAnchor.constraint(equalToConstant: cellWidth),
//            self.contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

//            mainStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
//            mainStackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
//            mainStackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: EAIncrement.one.rawValue),
//            mainStackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -EAIncrement.one.rawValue),

            self.spinner.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.spinner.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.spinner.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.spinner.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
    }

    /// Creates a UIStackView which contains the specified SubViews
    /// - Parameter views: The subviews that should be contained within the UIStackView
    /// - Returns: A UIStackView that contains the specified subviews
    private func createStackView(with views: [UIView]) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        for view in views {
            stack.addArrangedSubview(view)
    func printDebug(_ message: String) {
        if self.debug {
            print("$Log: \(message)")
        }
        return stack
    }

    // MARK: - Public Functions

    /// Configures the cell with a given ViewModel
    /// - Parameter viewModel: The ViewModel with which to configure the cell
    public func configure(with viewModel: EAGoalListItemViewModel) {
        self.addSubviewsAndEstablishConstraints(viewModel: viewModel)
//        self.setUIProperties(viewModel: viewModel)
        self.constructViews(with: viewModel)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}

final class CommentFlowLayout : UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
            layoutAttributesObjects?.forEach({ layoutAttributes in
                if layoutAttributes.representedElementCategory == .cell {
                    if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                        layoutAttributes.frame = newFrame
                    }
                }
            })
            return layoutAttributesObjects
        }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { fatalError() }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}

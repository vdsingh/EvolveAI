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

    /// The StackView that contains the content for this cell
    private var mainStack: EAFormElementView?

    /// Spinner for if the goal is loading
    private let spinner: EASpinner = {
        let spinner = EASpinner(backgroundColor: .systemGray)
        spinner.stopAnimating()
        return spinner
    }()

    // MARK: - Private Functions

    /// Adds subviews and establishes constraints for this view
    private func establishConstraints() {
        // Spinner code
        self.contentView.addSubview(self.spinner)
        NSLayoutConstraint.activate([
            // Spinner Constraints
            self.spinner.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.spinner.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.spinner.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.spinner.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])

        // Main Stack code
        guard let mainStack = self.mainStack else {
            fatalError("$Error: trying to establish constraints before instantiating the main stack.")
        }

        self.contentView.addSubview(mainStack)
        printDebug("Added main stack to content view")
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        let numItemsPerRow: CGFloat = 1
        let spacing: CGFloat = EAIncrement.two.rawValue
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = screenWidth / numItemsPerRow - (spacing * (numItemsPerRow + 1) / numItemsPerRow)

        NSLayoutConstraint.activate([
            // ContentView Constraints
            self.contentView.widthAnchor.constraint(equalToConstant: cellWidth),
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            // Main Stack constraints
            mainStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: EAIncrement.one.rawValue),
            mainStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -EAIncrement.one.rawValue),
            mainStack.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: EAIncrement.one.rawValue),
            mainStack.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -EAIncrement.one.rawValue)
        ])
    }

    // MARK: - Public Functions

    // TODO: Docstring

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }

    func configure(with viewModel: EAGoalListItemViewModel) {
        self.contentView.subviews.forEach({ $0.removeFromSuperview() })
        self.contentView.backgroundColor = viewModel.color
        self.contentView.layer.cornerRadius = EAIncrement.two.rawValue

        printDebug("configuring ListItem with viewModel \(viewModel). Task ViewModel: \(String(describing: viewModel.nextTaskViewModel))")

        // Main View Code
        guard let elementStack = EAUIElement.stack(
            axis: .vertical,
            spacing: .one,
            elements: [
                .label(text: viewModel.title, textStyle: EATextStyle.title, textColor: .white),
                .stack(axis: .horizontal, spacing: .one, elements: [
                    .image(eaImage: .clock, color: .white),
                    .label(text: "\(viewModel.numDays) days", textStyle: .heading1, textColor: .white)
                ])
            ]
        ).createView() as? EAStackView else {
            fatalError("$Error: Wrong element type")
        }

        // If there is a next task, add it to the element stack
        if let nextTaskViewModel = viewModel.nextTaskViewModel {
            elementStack.addElements([
                .label(text: "Next Task (Day \(viewModel.currentDayNumber)):", textStyle: .heading1, textColor: .white),
                .task(viewModel: nextTaskViewModel)
            ])
        }

        // Add the tags
        elementStack.addElements([
            .stack(axis: .horizontal, distribution: .fillProportionally, spacing: .one, elements: [
                .tag(text: "Hello"),
                .tag(text: "Goodbye")
            ])
        ])

        // Set the main stack to the created stack.
        self.mainStack = elementStack

        // Spinner Code
        if viewModel.loading {
            self.spinner.startAnimating()
        } else {
            self.spinner.stopAnimating()
        }

        self.establishConstraints()
        printDebug("contentview subview count: \(contentView.subviews.count)")
    }
}

final class CommentFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map { $0.copy() } as? [UICollectionViewLayoutAttributes]
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

extension EAGoalListItemCollectionViewCell {
    func printDebug(_ message: String) {
        if self.debug {
            print("$Log: \(message)")
        }
    }
}

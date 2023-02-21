//
//  EAGoalCollectionViewCell.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/14/23.
//

import UIKit

/// A UICollectionViewCell to hold EAGoal information
class EAGoalListItemCollectionViewCell: UICollectionViewCell, Debuggable {
    let debug: Bool = false

    /// Reuse identifier for the cell
    static let reuseIdentifier = "EAGoalCollectionViewCell"

    /// The StackView that contains the content for this cell
    private var mainStack: EAUIElementView?

    /// Spinner for if the goal is loading
    private let spinner: EASpinner = {
        let spinner = EASpinner(backgroundColor: .systemGray)
        spinner.stopAnimating()
        return spinner
    }()

    // TODO: Docstring
    private var cellWidth: CGFloat = 5
    private var refreshCollectionViewCallback: (() -> Void)?

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
        self.cellWidth = cellWidth
        printDebug("Cell Width: \(cellWidth)")
        NSLayoutConstraint.activate([
            // ContentView Constraints
            self.contentView.widthAnchor.constraint(equalToConstant: cellWidth),
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            // Main Stack constraints
            mainStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: EAIncrement.two.rawValue),
            mainStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -EAIncrement.two.rawValue),
            mainStack.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: EAIncrement.two.rawValue),
            mainStack.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -EAIncrement.two.rawValue)
        ])
    }
    
    // TODO: Docstring
    private func constructMainStack(with viewModel: EAGoalListItemViewModel) -> EAStackView {
        // Adds the title label and "Number of Days" label
        guard let elementStack = EAUIElement.stack(
            axis: .vertical,
            spacing: .one,
            elements: [
                .label(text: viewModel.title, textStyle: EATextStyle.title, textColor: viewModel.darkColor),
                .stack(axis: .horizontal, spacing: .one, elements: [
                    .image(eaImage: .clock, color: viewModel.darkColor, requiredHeight: EAIncrement.two.rawValue),
                    .label(text: "\(viewModel.numDays) days", textStyle: .heading1, textColor: viewModel.darkColor)
                ])
            ]
        ).createView() as? EAStackView else {
            fatalError("$Error: Wrong element type")
        }

        // If there is a next task for today, add it to the element stack
        if let nextTaskViewModel = viewModel.nextTaskViewModel {
            elementStack.addElements([
                .label(text: "Next Task (Day \(viewModel.currentDayNumber)):", textStyle: .heading1, textColor: viewModel.darkColor),
                .task(viewModel: nextTaskViewModel, taskCompletionChangedCallback: { [weak self] _ in
                    self?.refreshCollectionView()
                })
            ])
        }

        // Add the tags associated with the goal to the view
        elementStack.addElements([
            .stack(
                axis: .horizontal,
                distribution: .fillProportionally,
                spacing: .one,
                elements: viewModel.tags.compactMap { EAUIElement.tag(text: $0, color: viewModel.darkColor) }
            )
        ])

        return elementStack
    }
    
    private func refreshCollectionView() {
        if let refreshCollectionViewCallback = refreshCollectionViewCallback {
            printDebug("Refreshing CollectionView")
            refreshCollectionViewCallback()
        }
    }

    // MARK: - Public Functions

    // TODO: Docstring

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if let cellWidth = self.cellWidth {
            let targetSize = CGSize(width: cellWidth, height: 0)
            layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow
            )
            return layoutAttributes
        }
        
        fatalError("$Error: cell width not initialized")
    }

    func configure(with viewModel: EAGoalListItemViewModel, refreshCollectionViewCallback: (() -> Void)? = nil) {
        self.contentView.subviews.forEach({ $0.removeFromSuperview() })
        self.contentView.backgroundColor = viewModel.color
        self.contentView.layer.cornerRadius = EAIncrement.two.rawValue

        printDebug("configuring ListItem with viewModel \(viewModel). Task ViewModel: \(String(describing: viewModel.nextTaskViewModel))")

        if self.debug {
            self.backgroundColor = .yellow
        }

        // Set the refresh collection view callback
        self.refreshCollectionViewCallback = refreshCollectionViewCallback
        
        // Set the main stack to the created stack.
        self.mainStack = constructMainStack(with: viewModel)

        // Spinner Code
        if viewModel.loading {
            self.spinner.startAnimating()
        } else {
            self.spinner.stopAnimating()
        }

        self.establishConstraints()
        printDebug("ContentView subview count: \(contentView.subviews.count)")
    }
}

extension EAGoalListItemCollectionViewCell {
    func printDebug(_ message: String) {
        if self.debug {
            print("$Log: \(message)")
        }
    }
}

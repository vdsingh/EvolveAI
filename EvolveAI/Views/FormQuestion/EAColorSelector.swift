//
//  EAColorSelector.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/18/23.
//

import Foundation
import UIKit

/// A Form Element for selecting a color
final class EAColorSelector: UIStackView, EAFormElementView {

    /// The spacing between Color Views
    private let colorSpacing: CGFloat = 6

    /// The color options that the user can select
    private let colors: [UIColor]

    /// An array of the Color Views
    private var colorViews: [UIView]

    /// Callback for when a color is selected
    private let colorWasSelected: (UIColor) -> Void

    /// The number of colors in one row
    private var numColorsPerRow = 5

    /// The number of rows (computed)
    private var numRows: Int {
        let numColorsFloat = CGFloat(numColorsPerRow)
        let colorCount = CGFloat(colors.count)
        let numRows = colorCount.truncatingRemainder(dividingBy: numColorsFloat) == 0 ? colorCount / numColorsFloat : colorCount / numColorsFloat + 1
        return Int(numRows)
    }

    /// The height of each row (computed). Also the width of each color.
    private var rowHeight: CGFloat {
        let rowHeight = (UIScreen.main.bounds.width - (EAIncrement.two.rawValue * 2)) / CGFloat(self.numColorsPerRow)
        return rowHeight
    }

    /// The height required for this entire Form Element
    var requiredHeight: CGFloat {
        return CGFloat(numRows) * rowHeight
    }

    /// Normal initializer
    /// - Parameters:
    ///   - colors: The color options that the user can select
    ///   - colorWasSelectedCallback: Callback function for when a color is selected
    init(colors: [UIColor], colorWasSelectedCallback: @escaping (UIColor) -> Void) {
        self.colors = colors
        self.colorWasSelected = colorWasSelectedCallback
        self.colorViews = []
        super.init(frame: .zero)
        self.setUIProperties()
        self.addSubViewsAndEstablishConstraints(colors: colors)

        if colors.count.quotientAndRemainder(dividingBy: numColorsPerRow).remainder != 0 {
            print("$WARNING: Number of colors in color selector is not divisible by the number of colors per row. This will lead to rows with different numbers of colors")
        }
    }

    /// Adds the necessary Sub Views and establishes constraints
    /// - Parameter colors: The colors to add to this form element
    private func addSubViewsAndEstablishConstraints(colors: [UIColor]) {
        let colorStacks = createHStackViewsForColors(colors: colors)
        for stack in colorStacks {
            self.addArrangedSubview(stack)
        }
    }

    /// Sets the UI properties for this element
    private func setUIProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fillEqually
    }

    /// Creates an array of Horizontal stacks, which contain Color Views
    /// - Parameter colors: The colors that the user can choose from
    /// - Returns: An array of Horizontal stacks, which contain Color Views
    private func createHStackViewsForColors(colors: [UIColor]) -> [UIStackView] {
        var stacks = [UIStackView]()

        for index in 0..<colors.count {
            let color = colors[index]
            let colorView = UIView()
            colorView.translatesAutoresizingMaskIntoConstraints = false
            colorView.backgroundColor = color
            colorView.widthAnchor.constraint(equalToConstant: self.rowHeight - (self.colorSpacing * 2)).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: self.rowHeight - (self.colorSpacing * 2)).isActive = true
            colorView.layer.cornerRadius = (self.rowHeight - (self.colorSpacing * 2)) / 2
            colorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.colorWasClicked(_:))))

            if stacks.last == nil ||
                stacks.last?.arrangedSubviews.count ?? 0 >= self.numColorsPerRow {
                let stack = UIStackView()
                stack.translatesAutoresizingMaskIntoConstraints = false
                stack.distribution = .equalCentering
                stack.axis = .horizontal
                stack.alignment = .center
                stacks.append(stack)
            }

            stacks.last?.addArrangedSubview(colorView)
            self.colorViews.append(colorView)
        }

        return stacks
    }

    /// Function that is called when a color is clicked
    /// - Parameter sender: The UITapGestureRecognizer that sent the event
    @objc private func colorWasClicked(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view,
              let backgroundColor = view.backgroundColor else {
            print("$Error: color selector: color background color was nil")
            return
        }

        for colorView in colorViews {
            colorView.layer.borderColor = nil
            colorView.layer.borderWidth = 0
        }

        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.label.cgColor
        self.colorWasSelected(backgroundColor)
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}

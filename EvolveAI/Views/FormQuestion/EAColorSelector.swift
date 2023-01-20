//
//  EAColorSelector.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/18/23.
//

import Foundation
import UIKit

//TODO: DOCSTRINGS

final class EAColorSelector: UIStackView, EAFormElementView {
    private let colors: [UIColor]
    private let colorWasSelected: (UIColor) -> Void
    
    private var numColorsPerRow = 5
    private var numRows: Int {
        let numColorsFloat = CGFloat(numColorsPerRow)
        let colorCount = CGFloat(colors.count)
        let numRows = colorCount.truncatingRemainder(dividingBy: numColorsFloat) == 0 ? colorCount / numColorsFloat : colorCount / numColorsFloat + 1
        return Int(numRows)
    }
    private var rowHeight: CGFloat {
        let rowHeight = (UIScreen.main.bounds.width - (EAIncrement.two.rawValue * 2)) / CGFloat(self.numColorsPerRow)
        return rowHeight
    }
    
    var requiredHeight: CGFloat {
        return CGFloat(numRows) * rowHeight
    }
        
    init(colors: [UIColor], colorWasSelectedCallback: @escaping (UIColor) -> Void) {
        self.colors = colors
        self.colorWasSelected = colorWasSelectedCallback
        super.init(frame: .zero)
        self.setUIProperties()
        self.addSubViewsAndEstablishConstraints(colors: colors)
    }
    
    private func addSubViewsAndEstablishConstraints(colors: [UIColor]) {
        let colorStacks = createHStackViewsForColors(colors: colors)
        for stack in colorStacks {
            self.addArrangedSubview(stack)
        }
    }
    
    private func setUIProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 0
    }
    
    private func createHStackViewsForColors(colors: [UIColor]) -> [UIStackView] {
        var stacks = [UIStackView]()
        
        for i in 0..<colors.count {
            let color = colors[i]
            let colorView = UIView()
            colorView.translatesAutoresizingMaskIntoConstraints = false
            colorView.backgroundColor = color
            colorView.widthAnchor.constraint(equalToConstant: self.rowHeight).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: self.rowHeight).isActive = true
            colorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.colorWasClicked(_:))))
            

            if stacks.last == nil ||
                stacks.last!.arrangedSubviews.count >= self.numColorsPerRow {
                let stack = UIStackView()
                stack.translatesAutoresizingMaskIntoConstraints = false
                stack.distribution = .fill
                stack.axis = .horizontal
                stack.spacing = 0
                stack.alignment = .leading
                stacks.append(stack)
            }
            
            stacks.last?.addArrangedSubview(colorView)
        }
        
        if let last = stacks.last,
           last.arrangedSubviews.count < self.numColorsPerRow {
            let fillerView = UIView()
            fillerView.translatesAutoresizingMaskIntoConstraints = false
            fillerView.backgroundColor = .systemBackground
            stacks.last?.addArrangedSubview(fillerView)
        }

        return stacks
    }
    
    @objc private func colorWasClicked(_ sender: UITapGestureRecognizer) {
        print("Color was clicked")
        guard let view = sender.view,
              let backgroundColor = view.backgroundColor else {
            print("$Error: color selector: color background color was nil")
            return
        }
        self.colorWasSelected(backgroundColor)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

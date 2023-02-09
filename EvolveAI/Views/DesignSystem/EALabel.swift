//
//  EALabel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

// TODO: Docstring

final class EALabel: UILabel, EAFormElementView {
    var requiredHeight: CGFloat {
        self.font.pointSize * CGFloat(self.numberOfLines) + EAIncrement.one.rawValue
    }

    init(text: String, textStyle: EATextStyle) {
        super.init(frame: .zero)
        self.setUIProperties(text: text, textStyle: textStyle)
    }

    private func setUIProperties(text: String, textStyle: EATextStyle) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.font = textStyle.font
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

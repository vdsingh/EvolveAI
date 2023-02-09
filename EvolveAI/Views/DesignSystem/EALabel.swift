//
//  EALabel.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

//TODO: Docstring

final class EALabel: UILabel, EAFormElementView {
    var requiredHeight: CGFloat {
        self.font.pointSize * CGFloat(self.numberOfLines)
    }

    init(text: String) {
        super.init(frame: .zero)
        self.setUIProperties(text: text)
    }

    private func setUIProperties(text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

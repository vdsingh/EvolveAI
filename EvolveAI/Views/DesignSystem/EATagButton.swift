//
//  EATagButton.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit
final class EATagButton: UIButton {

    init(tag: String) {
        super.init(frame: .zero)
        self.setUIProperties(tag: tag)
    }

    private func setUIProperties(tag: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(tag, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .link
        self.layer.cornerRadius = EAIncrement.one.rawValue
        self.sizeToFit()

    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

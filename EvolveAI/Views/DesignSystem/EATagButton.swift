//
//  EATagButton.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

/// Custom Button View to represent goal tags
final class EATagButton: UIButton {
    
    /// Normal initializer
    /// - Parameter tag: The name of the tag (ex: "Fitness")
    init(tag: String) {
        super.init(frame: .zero)
        self.setUIProperties(tag: tag)
    }
    
    /// Sets the UI properties for this View
    /// - Parameter tag: The name for the tag
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

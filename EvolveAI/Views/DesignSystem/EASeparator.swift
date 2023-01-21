//
//  EASeparator.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit

/// A separator for Forms (a horizontal line)
class EASeparator: UIView, EAFormElementView {

    /// The height for this separator
    var requiredHeight: CGFloat = 1

    /// Normal Initializer
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .label
        self.heightAnchor.constraint(equalToConstant: requiredHeight).isActive = true
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

//
//  EASeparator.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/9/23.
//

import Foundation
import UIKit

/// A separator for Forms (a horizontal line)
final class EASeparator: UIView, EAUIElementViewStaticHeight {

    /// The height for this separator
    var requiredHeight: CGFloat = 1

    /// Normal Initializer
    init(color: UIColor = .label) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = color
        self.heightAnchor.constraint(equalToConstant: requiredHeight).isActive = true
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

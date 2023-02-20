//
//  EAImageView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/18/23.
//

import Foundation
import UIKit
// TODO: docstring
final class EAImageView: UIImageView, EAUIElementView {
    var requiredHeight: CGFloat

    init(eaImage: EAImage, color: UIColor, requiredHeight: CGFloat) {
        self.requiredHeight = requiredHeight
        super.init(frame: .zero)

        self.setUIProperties(eaImage: eaImage, color: color)
    }

    private func setUIProperties(eaImage: EAImage, color: UIColor) {
        self.image = eaImage.uiImage
        self.tintColor = color

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: self.requiredHeight),
            self.widthAnchor.constraint(equalToConstant: self.requiredHeight)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

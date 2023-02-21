//
//  EAImageView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/18/23.
//

import Foundation
import UIKit

/// Custom ImageView class
final class EAImageView: UIImageView, EAUIElementView {

    /// The height required for this ImageView
    var requiredHeight: CGFloat

    /// Normal Initializer
    /// - Parameters:
    ///   - eaImage: The image that is displayed by this ImageView
    ///   - color: The tint color for this ImageView
    ///   - requiredHeight: The height required for this ImageView
    init(eaImage: EAImage, tintColor: UIColor, requiredHeight: CGFloat) {
        self.requiredHeight = requiredHeight
        super.init(frame: .zero)

        self.setUIProperties(eaImage: eaImage, tintColor: tintColor)
    }
    
    /// Sets the UI Properties of the ImageView
    /// - Parameters:
    ///   - eaImage: The Image that this ImageView should display
    ///   - tintColor: The tintColor of the image
    private func setUIProperties(eaImage: EAImage, tintColor: UIColor) {
        self.image = eaImage.uiImage
        self.tintColor = tintColor

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: self.requiredHeight),
            self.widthAnchor.constraint(equalToConstant: self.requiredHeight)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

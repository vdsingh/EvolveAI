//
//  EAImage.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/18/23.
//

import Foundation
import UIKit

/// Images to be used in the application
enum EAImage: String {
    case clock

    /// The UIImage
    var uiImage: UIImage {
        if let image = UIImage(systemName: self.rawValue) {
            return image
        }

        return UIImage()
    }
}

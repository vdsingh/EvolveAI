//
//  EAImage.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/18/23.
//

import Foundation
import UIKit

// TODO: docstring
enum EAImage: String {
    case clock

    var uiImage: UIImage {
        if let image = UIImage(systemName: self.rawValue) {
            return image
        }

        return UIImage()
    }
}

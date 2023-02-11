//
//  EATextStyle.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

/// Text styles that text-based UI elements can use
enum EATextStyle {
    case title
    case heading1
    case heading2
    case body

    /// Computes a UIFont based on the TextStyle
    var font: UIFont {
        switch self {
        case .title:
            return UIFont.boldSystemFont(ofSize: EAIncrement.three.rawValue)

        case .heading1:
            return UIFont.boldSystemFont(ofSize: EAIncrement.two.rawValue)

        case .heading2:
            return UIFont.systemFont(ofSize: EAIncrement.two.rawValue)

        case .body:
            return UIFont.systemFont(ofSize: EAIncrement.one.rawValue)
        }
    }
}

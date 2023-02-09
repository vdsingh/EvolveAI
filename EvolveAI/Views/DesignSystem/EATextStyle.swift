//
//  EATextStyle.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/9/23.
//

import Foundation
import UIKit

// TODO: Docstrings
enum EATextStyle {
    case title
    case heading1
    case heading2
    case body

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

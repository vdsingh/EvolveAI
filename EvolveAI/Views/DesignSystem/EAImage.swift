//
//  EAImage.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/18/23.
//

import Foundation
import UIKit

//TODO: docstring
enum EAImage: String {
    case clock
    
    var uiImage: UIImage {
        return UIImage(systemName: self.rawValue) ?? .add
//        switch self {
//        case .clock:
//            return UIImage(systemName: )
//        }
    }
}

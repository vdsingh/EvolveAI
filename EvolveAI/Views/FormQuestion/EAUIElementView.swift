////
////  FormQuestionView.swift
////  EvolveAI
////
////  Created by Vikram Singh on 1/5/23.
////
//
import Foundation
import UIKit

/// All custom form questions must conform to this protocol
protocol EAUIElementView: UIView {

}

protocol EAUIElementViewStaticHeight: EAUIElementView {
    /// Value specifying what height the View should be (if it needs to be a hard value)
    var requiredHeight: CGFloat { get }
}

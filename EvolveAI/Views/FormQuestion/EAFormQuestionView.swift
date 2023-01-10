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
protocol EAFormQuestionView: UIView {
    /// Value specifying what height the View should be
    var requiredHeight: CGFloat { get }
}

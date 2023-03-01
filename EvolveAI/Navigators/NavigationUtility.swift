//
//  NavigationUtility.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/14/23.
//

import Foundation
import UIKit

/// Utility functions for Navigation
class NavigationUtility {

    /// Replaces the last ViewController of a given UINavigationController with a new ViewController
    /// - Parameters:
    ///   - viewController: The new UIViewController that we are pushing
    ///   - navigationController: The UINavigationController with which we are replacing the last ViewController
    public static func replaceLastVC(with viewController: UIViewController, navigationController: UINavigationController) {
        navigationController.viewControllers.removeLast()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
}

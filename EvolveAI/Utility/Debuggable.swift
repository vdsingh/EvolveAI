//
//  Debuggable.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/5/23.
//

import Foundation
protocol Debuggable {
    var debug: Bool { get }
    func printDebug(_ message: String)
}

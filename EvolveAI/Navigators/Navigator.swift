//
//  Navigator.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
protocol Navigator {
    associatedtype Destination

    func navigate(to destination: Destination)
}

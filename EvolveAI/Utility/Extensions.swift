//
//  Extensions.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/16/23.
//

import Foundation
extension String {
    public func numTokens(separatedBy charSet: CharacterSet) -> Int {
        let components = self.components(separatedBy: charSet)
        return components.count
    }
}

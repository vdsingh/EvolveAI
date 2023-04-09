//
//  Observable.swift
//  EvolveAI
//
//  Created by Vikram Singh on 4/9/23.
//

import Foundation

//TODO: Docstrings
class Observable<T> {
    
    let label: String
    
    var value: T? {
        didSet {
            print("$Log: value of observable [\(label)] was changed to [\(String(describing: value))]")
//            DispatchQueue.main.async {
                self.listener?(self.value)
//            }
        }
    }
    
    init(_ value: T?, label: String) {
        self.value = value
        self.label = label
    }
    
    private var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(self.value)
        self.listener = listener
    }
    
}

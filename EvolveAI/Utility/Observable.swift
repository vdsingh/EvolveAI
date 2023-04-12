//
//  Observable.swift
//  EvolveAI
//
//  Created by Vikram Singh on 4/9/23.
//

import Foundation

// TODO: Docstrings
class Observable<T>: Debuggable {

    let debug = false

    let label: String

    var value: T? {
        didSet {
            self.didSetValue()
        }
    }

    init(_ value: T?, label: String) {
        self.value = value
        self.label = label
        printDebug("initialized Observable with label: [\(label)]. value: [\(value)]")
        self.didSetValue()
    }

    private var listener: ((T?) -> Void)?

    private func didSetValue() {
        printDebug("value of observable [\(label)] was changed to [\(String(describing: value))]")
        self.listener?(self.value)
    }

    func bind(_ listener: @escaping (T?) -> Void) {
        printDebug("binded Observable with label [\(label)]")
        listener(self.value)
        self.listener = listener
    }

    func printDebug(_ message: String) {
        if self.debug {
            print("$Log (Observable): \(message)")
        }
    }
}

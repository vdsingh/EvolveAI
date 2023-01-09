//
//  EAGoalCreationFormViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit
class EAGoalCreationFormViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        let view = EAFormView(questions: [
            .textfield(question: "Question", textfieldPlaceholder: "Placeholder", textFieldWasEdited: { text in
                print("Text was edited! \(text)")
            })
        ])
        
        self.view = view
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

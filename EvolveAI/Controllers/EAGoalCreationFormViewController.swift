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
            .goalCreation(
                actionText: "I am going to",
                goalPlaceholder: "learn the violin",
                connectorText: "within",
                goalTextWasEdited: { text in
                    print("Goal text was edited: \(text)")
                },
                numDaysPlaceholder: "30",
                numDaysTextWasEdited: { text in
                    print("Num days text was edited: \(text)")
                },
                numDaysLabel: "days."
            ),
            .textfield(
                question: "Additional Details",
                textfieldPlaceholder: "My budget for a violin is $400.",
                textFieldWasEdited: { text in
                    print("Text was edited! \(text)")
                }
            ),
            
        ])
        
        self.view = view
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

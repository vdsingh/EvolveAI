//
//  ViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var prompt: String = ""
    var numDays: Int = 0
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let results = realm.objects(EAGoal.self)
        print("Results: \(results)")

        let questions: [EAFormQuestionViewModel] = [
            EAFormQuestionViewModel(
                question: "I want to:",
                questionResponse:
                        .textfield(placeholder: "learn the violin", textFieldWasEdited: { [weak self] text in
                            self?.prompt = text
                            print("Edited prompt: \(self?.prompt)")
                        })),
            EAFormQuestionViewModel(
                question: "within this many days:",
                questionResponse:
                        .textfield(placeholder: "30", textFieldWasEdited: { [weak self] text in
                            self?.numDays = Int(text)!
                            print("Edited days: \(self?.numDays)")
                        }))
        ]

        let subview = EAFormView(questions: questions)
        subview.backgroundColor = .yellow
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        
        let executeButton = UIButton()
        executeButton.backgroundColor = .red
        executeButton.translatesAutoresizingMaskIntoConstraints = false
        executeButton.addTarget(self, action: #selector(executeRequest), for: .touchUpInside)
        view.addSubview(executeButton)

        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: view.topAnchor),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            subview.rightAnchor.constraint(equalTo: view.rightAnchor),
            subview.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            executeButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            executeButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            executeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            executeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        
    }
    
    @objc func executeRequest() {
        let request = EAOpenAIRequest.completionsRequest(
            prompt: EAGoal.createOpenAICompletionsRequestString(goal: self.prompt, numDays: self.numDays)
        )

        EAService.shared.execute(request, expecting: EAOpenAICompletionsResponse.self, completion: { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let object):
                print("$Log: \(object)")
                let goal = EAGoal(goal: strongSelf.prompt,
                                  numDays: 10,
                                  apiResponse: object)
                
                DispatchQueue.main.async {
                    do {
                        try? strongSelf.realm.write {
                            strongSelf.realm.add(goal)
                        }
                    }
                    strongSelf.displayText(text: goal.aiResponse)
                    print("Set the label text to \(goal.aiResponse)")
                }
            case .failure(let error):
                print("$Error: \(String(describing: error))")
            }
        })
    }
    
    func displayText(text: String) {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.font = .systemFont(ofSize: 14)
        label.text = text
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

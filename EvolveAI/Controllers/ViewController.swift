//
//  ViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import UIKit

class ViewController: UIViewController {
    
    var prompt: String = ""
    var numDays: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questions: [FormQuestionViewModel] = [
            FormQuestionViewModel(
                question: "I want to:",
                questionResponse:
                        .textfield(placeholder: "learn the violin", textFieldWasEdited: { [weak self] text in
                            self?.prompt = text
                            print("Edited prompt: \(self?.prompt)")
                        })),
            FormQuestionViewModel(
                question: "within this many days:",
                questionResponse:
                        .textfield(placeholder: "30", textFieldWasEdited: { [weak self] text in
                            self?.numDays = Int(text)!
                            print("Edited days: \(self?.numDays)")
                        }))
        ]
        
        let subview = FormView(questions: questions)
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
//        view =
        
        
    }
    
    @objc func executeRequest() {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.font = .systemFont(ofSize: 14)
        label.text = "hello"
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

        let request = EAOpenAIRequest.completionsRequest(
            prompt: EAGoal.createOpenAICompletionsRequestString(goal: self.prompt, numDays: self.numDays)
        )

        EAService.shared.execute(request, expecting: EAOpenAICompletionsResponse.self, completion: { result in
            switch result {
            case .success(let object):
                print("$Log: \(object)")
                let goal = EAGoal(goal: self.prompt,
                                  numDays: 10,
                                  apiResponse: object)
                DispatchQueue.main.async {
                    label.text = goal.aiResponse
                    print("Set the label text to \(goal.aiResponse)")
                }
            case .failure(let error):
                print("$Error: \(String(describing: error))")
            }
        })
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.
    }
}

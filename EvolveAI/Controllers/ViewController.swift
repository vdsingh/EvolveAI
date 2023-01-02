//
//  ViewController.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        

        let prompt = "fuck more bitches and get more money"
        let numDays = 30
        let request = EAOpenAIRequest.completionsRequest(
            model: .davinci003,
            prompt: EAGoal.createOpenAICompletionsRequestString(goal: prompt, numDays: numDays)
        )
        
        EAService.shared.execute(request, expecting: EAOpenAICompletionsResponse.self, completion: { result in
            switch result {
            case .success(let object):
                print("$Log: \(object)")
                let goal = EAGoal(goal: prompt,
                                  numDays: numDays,
                                  apiResponse: object)
                DispatchQueue.main.async {
//                    label.text = goal.aiResponse
                    label.text = goal.aiResponse
                    print("Set the label text to \(goal.aiResponse)")
                }
            case .failure(let error):
                print("$Error: \(String(describing: error))")
            }
        })
    }


}


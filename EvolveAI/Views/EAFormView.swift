//
//  FormView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/5/23.
//

import Foundation
import UIKit

/// View for Forms
class EAFormView: UIView {

    /// The UIViews for the questions
    var questionViews: [UIView]

    /// Boolean representing whether the form is loading or not
    private var isFormLoading: Bool

    /// A spinner to indicate when we are loading data
    private let spinner: EASpinner = {
        let spinner = EASpinner(subText: "AI is working...")
        return spinner
    }()

    // MARK: - Initiailizer

    /// ViewModel initializer
    /// - Parameter viewModels: The EAFormQuestionViewModels to instantiate the View
    init(formElements: [EAFormElement]) {
        self.questionViews = []
        self.isFormLoading = false
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.addSubViewsAndEstablishConstraints(formElements: formElements)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        self.addGestureRecognizer(tap)
    }

    // MARK: - Private Functions

    /// Add the subviews to the view and establish constraints
    /// - Parameter formElements: The EAFormElements which specify the subviews to add
    private func addSubViewsAndEstablishConstraints(formElements: [EAFormElement]) {
        let stack = constructFormElementStackView(formElements: formElements)
        stack.spacing = EAIncrement.two.rawValue
        self.addSubview(stack)
        self.addSubview(self.spinner)

        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: EAIncrement.two.rawValue),
            stack.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -EAIncrement.two.rawValue),
            stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: EAIncrement.two.rawValue),

            self.spinner.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            self.spinner.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            self.spinner.heightAnchor.constraint(equalToConstant: self.spinner.requiredHeight),
            self.spinner.widthAnchor.constraint(equalToConstant: self.spinner.requiredHeight)
        ])
    }

    /// Constructs a UIStackView that contains all of the form element views
    /// - Parameter formElements: the EAFormElement which specify the subviews to add
    /// - Returns: a UIStackView that contains all of the Form Element views
    private func constructFormElementStackView(formElements: [EAFormElement]) -> UIStackView {
        let elementStack = UIStackView()
        elementStack.translatesAutoresizingMaskIntoConstraints = false
        elementStack.axis = .vertical

        for formElement in formElements {
            let view = formElement.createView()
            self.questionViews.append(view)
            elementStack.addArrangedSubview(view)

            view.heightAnchor.constraint(equalToConstant: view.requiredHeight).isActive = true
        }

        return elementStack
    }

    // MARK: - Public Functions

    /// Toggle whether the form is loading or not (the spinners active status, user interaction)
    /// - Parameter isActive: Whether the page is loading or not
    public func setLoading(isLoading: Bool) {
        if isLoading {
            self.isUserInteractionEnabled = false
            self.isFormLoading = true
            self.spinner.startAnimating()
        } else {
            self.isUserInteractionEnabled = true
            self.isFormLoading = false
            self.spinner.stopAnimating()
        }
    }

    /// Getter for whether the form is loading or not
    /// - Returns: A boolean describing whether the form is loading or not
    public func isLoading() -> Bool {
        return self.isFormLoading
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

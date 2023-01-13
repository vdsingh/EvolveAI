//
//  EASpinner.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/12/23.
//

import Foundation
import UIKit

/// Custom Activity Indicator Spinner View for this application
class EASpinner: UIView {

    /// The container for the spinner. Provides a background for accessbility purposes
    private let spinnerContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .label.withAlphaComponent(0.7)
        container.layer.cornerRadius = EAIncrement.one.rawValue
        container.isHidden = true
        return container
    }()
    
    /// A spinner for when we need to indicate loading.
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    /// Normal Initializer
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviewsAndEstablishConstraints()
    }
    
    // MARK: - Private Functions
    
    /// Adds the subviews and establishes constraints
    private func addSubviewsAndEstablishConstraints() {
        self.spinnerContainer.addSubview(self.spinner)
        self.addSubview(spinnerContainer)
        
        NSLayoutConstraint.activate([
            self.spinnerContainer.heightAnchor.constraint(equalTo: self.spinner.heightAnchor, constant: EAIncrement.one.rawValue),
            self.spinnerContainer.widthAnchor.constraint(equalTo: self.spinner.widthAnchor, constant: EAIncrement.one.rawValue),
            self.spinnerContainer.topAnchor.constraint(equalTo: self.topAnchor),
            self.spinnerContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.spinnerContainer.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.spinnerContainer.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            self.spinner.centerXAnchor.constraint(equalTo: self.spinnerContainer.centerXAnchor),
            self.spinner.centerYAnchor.constraint(equalTo: self.spinnerContainer.centerYAnchor),
        ])
    }
    
    // MARK: - Public Functions
    
    /// Function to call when we want to start animating the spinner
    public func startAnimating() {
        spinnerContainer.isHidden = false
        spinner.startAnimating()
    }
    
    /// Function to call when we want to stop animating the spinner
    public func stopAnimating() {
        spinnerContainer.isHidden = true
        spinner.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

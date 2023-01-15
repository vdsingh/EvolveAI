//
//  EASpinner.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/12/23.
//

import Foundation
import UIKit

/// Custom Activity Indicator Spinner View for this application
class EASpinner: UIStackView, EAFormElementView {
    
    /// Required height for this EASpinner
    var requiredHeight: CGFloat = 120

    /// A spinner for when we need to indicate loading.
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    /// Label for subtext of the spinner
    private let subTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemBackground
        label.numberOfLines = 0
        return label
    }()
    
    /// Normal Initializer
    /// - Parameter subText: Sub Text String (if any) to display under the spinner
    init(subText: String? = nil) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviewsAndEstablishConstraints()
        self.setUIProperties(subText: subText)
    }
    
    // MARK: - Private Functions
    
    /// Set the UI properties for this View
    /// - Parameter subText: the SubText (if any) for this spinner
    private func setUIProperties(subText: String?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .label.withAlphaComponent(0.7)
        self.layer.cornerRadius = EAIncrement.one.rawValue
        self.isHidden = true
        self.axis = .vertical
        self.distribution = .fillEqually
        self.alignment = .center
        self.spacing = 0

        if let subText = subText {
            self.subTextLabel.text = subText
            self.addArrangedSubview(self.subTextLabel)
        }
    }
    
    /// Adds the subviews and establishes constraints
    private func addSubviewsAndEstablishConstraints() {
        self.addArrangedSubview(self.spinner)
    }
    
    // MARK: - Public Functions
    
    /// Function to call when we want to start animating the spinner
    public func startAnimating() {
        self.isHidden = false
        spinner.startAnimating()
    }
    
    /// Function to call when we want to stop animating the spinner
    public func stopAnimating() {
        self.isHidden = true
        spinner.stopAnimating()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

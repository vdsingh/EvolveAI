//
//  EAGoalView.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/8/23.
//

import Foundation
import UIKit
import RealmSwift

/// View to display an individual goal and all of its information
class EAGoalView: UIView {
    
    /// Label that shows the number of days for this goal
    let numDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: EAIncrement.two.rawValue, weight: .regular)
        return label
    }()
    
    /// Label that shows the additional details for the goal
    let additionalDetailsLabel: UILabel = {
        let detailsLabel = UILabel()
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.numberOfLines = 0
        return detailsLabel
    }()
    
    /// ScrollView that allows users to scroll up and down through the View
    let guideScrollView: UIScrollView = {
        let guideScrollView = UIScrollView()
        guideScrollView.translatesAutoresizingMaskIntoConstraints = false
        guideScrollView.showsVerticalScrollIndicator = false
        return guideScrollView
    }()
    
    /// StackView that contains the content for the ScrollView.
    let guideContentView: UIStackView = {
        let guideContentView = UIStackView()
        guideContentView.translatesAutoresizingMaskIntoConstraints = false
        guideContentView.axis = .vertical
        guideContentView.alignment = .fill
        guideContentView.distribution = .equalSpacing
        guideContentView.spacing = EAIncrement.one.rawValue
        return guideContentView
    }()
    
    /// Initializer to instantiate this View with a ViewModel
    /// - Parameter viewModel: The ViewModel to use for the View's data
    init(viewModel: EAGoalViewModel) {
        self.numDaysLabel.text = "within \(viewModel.numDays) Days:"
        self.additionalDetailsLabel.text = viewModel.additionalDetails
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.addSubviewsAndEstablishConstraints(dayGuides: viewModel.dayGuides)
    }
    
    // MARK: - Private Functions
    
    /// Adds the subviews of the View and activates the constraints
    /// - Parameter dayGuides: List of EAGoalDayGuide objects that we need to add to our View
    private func addSubviewsAndEstablishConstraints(dayGuides: List<EAGoalDayGuide>) {
        self.addSubview(guideScrollView)
        self.guideScrollView.addSubview(self.guideContentView)
        self.guideContentView.addArrangedSubview(self.numDaysLabel)
        self.guideContentView.addArrangedSubview(EASeparator())
        self.addDayGuidesToUI(dayGuides)
        self.guideContentView.addArrangedSubview(EASeparator())
        self.guideContentView.addArrangedSubview(self.additionalDetailsLabel)
        NSLayoutConstraint.activate([
            self.guideScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            self.guideScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.guideScrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: EAIncrement.two.rawValue),
            self.guideScrollView.rightAnchor.constraint(equalTo: rightAnchor, constant: -EAIncrement.two.rawValue),

            self.guideContentView.topAnchor.constraint(equalTo: guideScrollView.topAnchor),
            self.guideContentView.bottomAnchor.constraint(equalTo: guideScrollView.bottomAnchor),
            self.guideContentView.leftAnchor.constraint(equalTo: guideScrollView.leftAnchor),
            self.guideContentView.rightAnchor.constraint(equalTo: guideScrollView.rightAnchor),
            self.guideContentView.widthAnchor.constraint(equalTo: guideScrollView.widthAnchor)
        ])
    }
    
    /// Adds EAGoalDayGuide objects to the View
    /// - Parameter dayGuides: A list of EAGoalDayGuide objects to add to the view
    private func addDayGuidesToUI(_ dayGuides: List<EAGoalDayGuide>) {
        for guide in dayGuides {
            var daysText = "Day \(guide.days[0]):"
            if guide.days.count > 1 {
                daysText = "Days \(guide.days[0]) - \(guide.days[1]):"
            }
            
            let guideViewModel = EADayGuideViewModel(daysText: daysText, tasksTexts: guide.tasks)
            let guideView = EADayGuideView(with: guideViewModel)
            self.guideContentView.addArrangedSubview(guideView)
        }
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

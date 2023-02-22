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
class EAGoalDetailsView: UIView {

    /// ScrollView that allows users to scroll up and down through the View
    let guideScrollView: UIScrollView = {
        let guideScrollView = UIScrollView()
        guideScrollView.translatesAutoresizingMaskIntoConstraints = false
        guideScrollView.showsVerticalScrollIndicator = false
        return guideScrollView
    }()

    /// StackView that contains the content for the ScrollView.
    let guideContentView: EAStackView = {
        let guideContentView = EAStackView(
            axis: .vertical,
            alignment: .fill,
            distribution: .equalSpacing,
            spacing: EAIncrement.one,
            subViews: []
        )

        return guideContentView
    }()

    /// Initializer to instantiate this View with a ViewModel
    /// - Parameter viewModel: The ViewModel to use for the View's data
    init(viewModel: EAGoalDetailsViewModel) {
        super.init(frame: .zero)
        self.backgroundColor = viewModel.color
        self.addSubviewsAndEstablishConstraints(
            viewModel: viewModel,
            dayGuideViewModels: viewModel.dayGuideViewModels,
            separatorColor: viewModel.darkColor
        )
    }

    // MARK: - Private Functions

    /// Adds the subviews of the View and activates the constraints
    /// - Parameter dayGuides: List of EAGoalDayGuide objects that we need to add to our View
    private func addSubviewsAndEstablishConstraints(
        viewModel: EAGoalDetailsViewModel,
        dayGuideViewModels: [EAGoalDayGuideViewModel],
        separatorColor: UIColor
    ) {
        self.addSubview(guideScrollView)
        self.guideScrollView.addSubview(self.guideContentView)
        self.guideContentView.addElements([
            .elementStack(axis: .horizontal, spacing: EAIncrement.one, elements: [
                .image(eaImage: .clock, tintColor: viewModel.darkColor, requiredHeight: EAIncrement.two.rawValue),
                .label(text: viewModel.numDaysString, textColor: viewModel.darkColor)
            ]),
            .label(text: viewModel.dateCreatedString, textColor: viewModel.darkColor),
            .elementStack(
                axis: .horizontal,
                distribution: .fillProportionally,
                spacing: .one,
                elements:
                    viewModel.tagStrings.compactMap({
                        EAUIElement.tag(text: $0, color: viewModel.darkColor)
                    })
            ),
            .separator(color: separatorColor)
        ])

        self.guideContentView.addSubviews(dayGuideViewModels.compactMap({
            EADayGuideView(with: $0)
        }))

        if !viewModel.additionalDetails.isEmpty {
            self.guideContentView.addElements([
                .separator(color: separatorColor),
                .label(text: viewModel.additionalDetails, textColor: viewModel.darkColor)
            ])
        }

        self.guideContentView.addArrangedSubview(EASeparator(color: separatorColor))

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

    required init?(coder: NSCoder) {
        return nil
    }
}

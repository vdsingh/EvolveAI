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
class EAGoalDetailsView: UIView, Debuggable {

    let debug = false

    /// The DayGuideView that is relevant for today
    var todaysDayGuideView: EADayGuideView?

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
    
    lazy var spinner: EASpinner = {
        let spinner = EASpinner(color: self.viewModel.darkColor, backgroundColor: .clear)
        return spinner
    }()

    /// Initializer to instantiate this View with a ViewModel
    /// - Parameter viewModel: The ViewModel to use for the View's data
    init(viewModel: EAGoalDetailsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = viewModel.color
        self.addSubviewsAndEstablishConstraints(
            viewModel: viewModel,
            dayGuideViewModels: viewModel.dayGuideViewModels,
            separatorColor: viewModel.darkColor
        )
    }
    
    func setLoading(_ isLoading: Bool) {
        printDebug("Set the loading status of EAGoalDetailsView to \(isLoading)")
        if isLoading {
            self.spinner.startAnimating()
        } else {
            self.spinner.stopAnimating()
        }
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
            .elementStack(axis: .horizontal, spacing: EAIncrement.half, elements: [
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

        if Flags.developerMode {
            self.guideContentView.addElements([
                .label(text: "Developer Information", textStyle: .heading1, textColor: viewModel.darkColor),
                .label(text: "Model Used: \(viewModel.modelUsedText)", textColor: viewModel.darkColor),
                .label(text: "Message History: \n\"\(viewModel.messageHistoryString ?? "")\"", textColor: viewModel.darkColor),
                .button(buttonText: "Print Day Guides to Console", enabledOnStart: true, buttonPressed: { _ in
                    print("Printing Day Guides to Console. Count: \(dayGuideViewModels.count)")
                    for dayGuideViewModel in dayGuideViewModels {
                        print("\t: \(dayGuideViewModel.description)")
                    }
                }),
                .separator(color: separatorColor)
            ])
        }

        if let dayGuideViewStack = EAUIElement.stack(axis: .vertical, spacing: .two).createView() as? EAStackView {
            dayGuideViewStack.addSubviews(dayGuideViewModels.compactMap({
                let dayGuideView = EADayGuideView(with: $0)
                if $0.associatedDate.occursOnSameDate(as: Date()) {
                    self.todaysDayGuideView = dayGuideView
                    dayGuideView.setTitleColor(EAColor.success.darken(by: 20))
                }

                return dayGuideView
            }))
            self.guideContentView.addSubview(dayGuideViewStack)
        } else {
            fatalError("$Error: Couldn't create stack as EAStackView")
        }

        if !viewModel.additionalDetails.isEmpty {
            self.guideContentView.addElements([
                .separator(color: separatorColor),
                .label(text: viewModel.additionalDetails, textColor: viewModel.darkColor)
            ])
        }

//        self.spinner.spinner.color = viewModel.darkColor
        self.guideContentView.addSubview(self.spinner)
        self.guideContentView.addElement(.separator(color: separatorColor))

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

    /// Scrolls to the DayGuideView for today
    func scrollToTodaysDayGuideView() {

        // Scroll to todays day guide if there is one
        if let todaysDayGuideView = self.todaysDayGuideView {
            printDebug("Scrolling to todays day guide view")
            let additionalOffset = UIScreen.main.bounds.height / 3
            self.guideScrollView.scrollToView(view: todaysDayGuideView, animated: true, additionalOffset: additionalOffset)
        } else {
            printDebug("Not scrolling to todays day guide view")
        }
    }

    required init?(coder: NSCoder) {
        return nil
    }
}

extension EAGoalDetailsView {
    func printDebug(_ message: String) {
        if self.debug {
            print("$Log: \(message)")
        }
    }
}

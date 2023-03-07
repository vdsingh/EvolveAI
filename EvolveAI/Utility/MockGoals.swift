//
//  MockGoals.swift
//  EvolveAI
//
//  Created by Vikram Singh on 2/23/23.
//

import Foundation
import UIKit

/// Mock Goals
final class MockGoals {

    /// A random color that a goal can be
    static var randomGoalColor: UIColor {
        EAColor.goalColors.randomElement()?.uiColor ?? EAColor.pastelOrange.uiColor
    }

    /// Random Creation and Start Date for Goals
    static var randomCreationAndStartDate: (creationDate: Date, startDate: Date) {
        let creationDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()
        let startDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 0..<8), to: creationDate) ?? Date()
        return (creationDate, startDate)
    }

    /// A Mock goal for learning the violin
    static let learnViolin: EAGoal = {
        let randomDates = randomCreationAndStartDate
        let goal = EAGoal(
            creationDate: randomDates.creationDate,
            startDate: randomDates.startDate,
            id: UUID().uuidString,
            goal: "Learn the Violin",
            numDays: 10,
            additionalDetails: "",
            color: EAColor.pastelRed.uiColor,
            aiResponse: """
                [learning, violin, music]
                Day 1: Practice holding the bow&%Learn basic notes G-A-B-C&%Research beginner music
                Day 2: Practice changing between different notes&%Listen to music pieces&%Find a song you want to learn
                Day 3: Practice finger placement&%Listen to music pieces&%Learn dynamics
                Day 4: Practice proper bowing technique&%Listen to pieces&%Start practicing song chosen
                Day 5: Practice changing between notes accurately&%Listen to pieces&%Practice song
                Day 6: Practice alternate bowing techniques&%Listen to pieces&%Polish chosen song
                Day 7: Work on accuracy of notes&%Listen to music&%Practice coordination
                Day 8: Practice dynamics&%Listen to songs&%Practice song with accompaniment
                Day 9: Experiment with improvisation&%Listen to pieces&%Perfect chosen song
                Day 10: Put it all together
            """,
            modelUsed: .EAMockingModel(model: .mocked),
            endpointUsed: .EAMockingEndpoint(endpoint: .mocked)
        )

        return goal
    }()

    /// A mock goal for learning carpentry
    static let learnCarpentry: EAGoal = {
        let randomDates = randomCreationAndStartDate
        let goal = EAGoal(
            creationDate: randomDates.creationDate,
            startDate: randomDates.startDate,
            id: UUID().uuidString,
            goal: "Learn Carpentry",
            numDays: 10,
            additionalDetails: "",
            color: EAColor.pastelOrange.uiColor,
            aiResponse: """
                [Carpentry,Construction,DIY]
                Day 1: Research various carpentry projects &%Gather the tools/materials needed &%Create a timeline/schedule.
                Day 2: Determine the project/task &%Practice on scrap wood.
                Day 3: Make a sketch/drawing of the design &%Test design on scrap wood with tools.
                Day 4: Cut the pieces of wood to size &%Assemble the pieces to get a rough form.
                Day 5: Make adjustments to ensure accuracy &%Sand the surface to ensure uniformity.
                Day 6: Stain wood &%Apply protective sealant to wood.
                Day 7: Measure and mark tools for installation &%Attach tools to wood with adhesive.
                Day 8: Hammer nails to secure tools &%Create decorative elements as desired.
                Day 9: Put finishing touches &%Ensure stability of wood pieces.
                Day 10: Add hardware or paint as needed.
            """,
            modelUsed: .EAMockingModel(model: .mocked),
            endpointUsed: .EAMockingEndpoint(endpoint: .mocked)
        )

        return goal
    }()

    /// A mock goal for going to the gym
    static let goToGym: EAGoal = {
        let randomDates = randomCreationAndStartDate
        let goal = EAGoal(
            creationDate: randomDates.creationDate,
            startDate: randomDates.startDate,
            id: UUID().uuidString,
            goal: "Go to the Gym",
            numDays: 12,
            additionalDetails: "",
            color: EAColor.pastelYellow.uiColor,
            aiResponse: """
                [Fitness,Goal,Progress]
                Day 1: Wake up early &%Stretch &% Set a timer for gym
                Day 2: Go to gym &% Warm up &% Allotted workout
                Day 3: 5min cardio &% 30 min weights &% Stretching
                Day 4: 30 min running &% Resistance Training &% Cool down
                Day 5: 5min HIIT &%Weights &% Yoga
                Day 6: Yoga &% 20 min strength training &% Cool Down
                Day 7: 10 min cardio &% Interval Training &% Stretch
                Day 8: Core training &% 25 min Cycling &% WAR
                Day 9: 20 Min elliptical training &% Strengthening &% Stretching
                Day 10: 5 min HIIT &% 20 min weightlifting &% Cool down
                Day 11: 25 min running &% Resisted Training &% Yoga
                Day 12: 15 min elliptical
            """,
            modelUsed: .EAMockingModel(model: .mocked),
            endpointUsed: .EAMockingEndpoint(endpoint: .mocked)
        )

        return goal
    }()

    /// An array of all mock goals
    static let mockGoals = [learnViolin, learnCarpentry, goToGym]
}

//
//  EAGoalTest.swift
//  EvolveAITests
//
//  Created by Vikram Singh on 1/20/23.
//

import XCTest
import RealmSwift
@testable import EvolveAI

final class EAGoalTest: XCTestCase {
    let goal = EAGoal(
        goal: "learn the violin",
        numDays: 10,
        additionalDetails: "",
        colorHex: "#ffffff",
        aiResponse: """
Day 1: Procure a violin and bow, locate a tuner and rosin. Listen to music and watch videos on violin playing technique.&%
Day 2: Tune the violin. Continue watching videos on playing technique. Try playing some strings.&%
Day 3: Practice placing hands on the  violin and bow. Try some basic bowing and fingering exercises. Cityscapes if possible.&%
Day 4: Try some musical pieces or exercises. Practice scales and arpeggios. Commit yourself to practice one hour at least.&%
Day 5: Stick to a practice plan and continue working on the basics. Identify and focus on weak spots.&%
Day 6: Pay attention to fingering, phrasing & establishing proper technique. Download the sheet music of any chosen pieces & start memorizing them.&%
Day 7: Practice with a metronome and/or a timer. Record yourself and constantly listen to your recordings, compare and analyze them.&%
Day 8: Aim to add more musicality to your playing and develop more musical maturity and sensitivity.&%
Day 9: Working on dynamics, articulation, and expression. Continue to review and practice fundamentals and work on weak spots&%
Day 10: Consolidate and synthesize all that you have learned. Listen to teaching recordings and analyze the differences.
"""
    )

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testTaskCreation() {
        for i in 0..<self.goal.dayGuides.count {
            let guide = self.goal.dayGuides[i]
            XCTAssertTrue(guide.days.count == 1)
            //            XCTAssertTrue(guide.days.first == i+1)
        }
    }

}

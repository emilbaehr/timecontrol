//
//  File.swift
//  
//
//  Created by Emil Christensen on 16/09/2021.
//

@testable import TimeControl
import Foundation
import XCTest

class TimeControlTests: XCTestCase {
    
    struct Move {
        let player: Player
        let move: Int
        let duration: TimeInterval
        var increment: TimeInterval? = nil
        var delay: TimeInterval? = nil
        let remaining: TimeInterval
    }
    
    fileprivate func makeMoves(_ moves: [TimeControlTests.Move], with timekeeper: Timekeeper) {
        
        // The total time of the game being played.
        var totalTime: TimeInterval = 0
        
        for move in moves {
            
//            let increment = move.increment ?? 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + move.duration + totalTime) {
                try? timekeeper.switchTurn()
                XCTAssertEqual(move.player.remainingTime, move.remaining, accuracy: 0.1)
                print("Remaining: \(move.player.remainingTime)")
                print("Movecount: \(move.move)")
            }
            
            totalTime += move.duration
        }
    }
    
    fileprivate func start(_ timekeeper: Timekeeper) {
        do {
            try timekeeper.start()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func fulfill(_ expectation: XCTestExpectation, after expectedTimeout: TimeInterval) {
        // Fulfilling the expectation here will mean that all moves were correctly timekept.
        DispatchQueue.main.asyncAfter(deadline: .now() + expectedTimeout + 1) {
            expectation.fulfill()
        }
    }
    
    func testTimeControlInitialisation() {
        let thinkingTime = TimeInterval(60)
        let timeControl = TimeControl(of: thinkingTime)
        let timekeeper = Timekeeper(playerOne: timeControl, playerTwo: timeControl)
        
        XCTAssertEqual(timekeeper.playerOne.remainingTime, thinkingTime)
        XCTAssertEqual(timekeeper.playerTwo.remainingTime, thinkingTime)
    }
    
    func testSuddenDeathTimekeeping() {

        continueAfterFailure = false

        let thinkingTime = TimeInterval(60)

        let timeControl = TimeControl(of: thinkingTime)
        let timekeeper = Timekeeper(playerOne: timeControl, playerTwo: timeControl)
        let expectation = XCTestExpectation(description: "Timekeeper correctly starts and keeps track of the time when players take turns.")

        let moves = [
            Move(player: timekeeper.playerOne, move: 1, duration: 2, remaining: 58),
            Move(player: timekeeper.playerTwo, move: 1, duration: 2, remaining: 58),
            Move(player: timekeeper.playerOne, move: 2, duration: 1, remaining: 57),
            Move(player: timekeeper.playerTwo, move: 2, duration: 1, remaining: 57),
            Move(player: timekeeper.playerOne, move: 3, duration: 0.5, remaining: 56.5),
            Move(player: timekeeper.playerTwo, move: 3, duration: 0.5, remaining: 56.5)
        ]
        
        let expectedPlayTime: TimeInterval = moves.reduce(0) { $0 + $1.duration }

        start(timekeeper)
        makeMoves(moves, with: timekeeper)
        fulfill(expectation, after: expectedPlayTime)
        
        // Another way to test could be to compute the values of the players timesheet.
        // Wait for the expectation to fulfill.
        wait(for: [expectation], timeout: expectedPlayTime + 1)
    }
    
    func testFischerTimekeeping() {
        
        continueAfterFailure = false

        let thinkingTime = TimeInterval(60)

        let timeControl = TimeControl(stages: [Fischer(of: thinkingTime, increment: 5)])
        let timekeeper = Timekeeper(playerOne: timeControl, playerTwo: timeControl)
        let expectation = XCTestExpectation(description: "Timekeeper correctly starts and keeps track of the time when players take turns.")

        let moves = [
            Move(player: timekeeper.playerOne, move: 1, duration: 2, remaining: 63),
            Move(player: timekeeper.playerTwo, move: 1, duration: 2, remaining: 63),
            Move(player: timekeeper.playerOne, move: 2, duration: 1, remaining: 67),
            Move(player: timekeeper.playerTwo, move: 2, duration: 1, remaining: 67),
            Move(player: timekeeper.playerOne, move: 3, duration: 0.5, remaining: 71.5),
            Move(player: timekeeper.playerTwo, move: 3, duration: 0.5, remaining: 71.5)
        ]
        
        let expectedPlayTime: TimeInterval = moves.reduce(0) { $0 + $1.duration }

        start(timekeeper)
        makeMoves(moves, with: timekeeper)
        fulfill(expectation, after: expectedPlayTime)

        // Wait for the expectation to fulfill.
        wait(for: [expectation], timeout: expectedPlayTime + 1)
        
    }
    
    func testBronsteinTimekeeping() {
        
    }
    
    func testUSDelayTimekeeping() {
        
    }
}

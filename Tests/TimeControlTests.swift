//
//  File.swift
//  
//
//  Created by Emil Christensen on 16/09/2021.
//

@testable import TimeControl
import Foundation
import XCTest

protocol Move {
    var movecount: Int { get }
    var player: Player { get }
    var duration: TimeInterval { get }
    var remaining: TimeInterval { get }
}

class TimeControlTests: XCTestCase {
    
    struct Pause: Move {
        var movecount: Int
        var player: Player
        var duration: TimeInterval
        var remaining: TimeInterval
    }
    
    struct Turn: Move {
        var movecount: Int
        var player: Player
        var duration: TimeInterval
        var remaining: TimeInterval
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

        // Given:
        let thinkingTime = TimeInterval(60)

        let timeControl = TimeControl(of: thinkingTime)
        let timekeeper = Timekeeper(playerOne: timeControl, playerTwo: timeControl)
        let expectation = XCTestExpectation(description: "Timekeeper correctly starts and keeps track of the time when players take turns.")

        let moves: [Move] = [
            Turn(movecount: 1, player: timekeeper.playerOne, duration: 2, remaining: 58),
            Turn(movecount: 1, player: timekeeper.playerTwo, duration: 2, remaining: 58),
            Turn(movecount: 2, player: timekeeper.playerOne, duration: 1, remaining: 57),
            Turn(movecount: 2, player: timekeeper.playerTwo, duration: 1, remaining: 57),
            Turn(movecount: 3, player: timekeeper.playerOne, duration: 0.5, remaining: 56.5),
            Turn(movecount: 3, player: timekeeper.playerTwo, duration: 0.5, remaining: 56.5)
        ]
        
        let expectedPlayTime: TimeInterval = moves.reduce(0) { $0 + $1.duration }

        // When:
        start(timekeeper)
        makeMoves(moves, with: timekeeper)
        fulfill(expectation, after: expectedPlayTime)
        
        // Another way to test could be to compute the values of the players timesheet.
        // Wait for the expectation to fulfill.
        wait(for: [expectation], timeout: expectedPlayTime + 1)
    }
    
    func testFischerTimekeeping() {
        
        continueAfterFailure = false

        // Given:
        let thinkingTime = TimeInterval(60)

        let timeControl = TimeControl(stages: [Fischer(of: thinkingTime, increment: 5)])
        let timekeeper = Timekeeper(playerOne: timeControl, playerTwo: timeControl)
        let expectation = XCTestExpectation(description: "Timekeeper correctly starts and keeps track of the time when players take turns.")

        let moves = [
            Turn(movecount: 1, player: timekeeper.playerOne, duration: 2, remaining: 63),
            Turn(movecount: 1, player: timekeeper.playerTwo, duration: 2, remaining: 63),
            Turn(movecount: 2, player: timekeeper.playerOne, duration: 1, remaining: 67),
            Turn(movecount: 2, player: timekeeper.playerTwo, duration: 1, remaining: 67),
            Turn(movecount: 3, player: timekeeper.playerOne, duration: 0.5, remaining: 71.5),
            Turn(movecount: 3, player: timekeeper.playerTwo, duration: 0.5, remaining: 71.5)
        ]
        
        let expectedPlayTime: TimeInterval = moves.reduce(0) { $0 + $1.duration }

        // When:
        start(timekeeper)
        makeMoves(moves, with: timekeeper)
        fulfill(expectation, after: expectedPlayTime)

        // Wait for the expectation to fulfill.
        wait(for: [expectation], timeout: expectedPlayTime + 1)
    }
    
    func testBronsteinTimekeeping() {
        
        continueAfterFailure = false

        // Given:
        let thinkingTime = TimeInterval(60)

        let timeControl = TimeControl(stages: [Bronstein(of: thinkingTime, increment: 2)])
        let timekeeper = Timekeeper(playerOne: timeControl, playerTwo: timeControl)
        let expectation = XCTestExpectation(description: "Timekeeper correctly starts and keeps track of the time when players take turns.")

        let moves = [
            Turn(movecount: 1, player: timekeeper.playerOne, duration: 2, remaining: 60),
            Turn(movecount: 1, player: timekeeper.playerTwo, duration: 2, remaining: 60),
            Turn(movecount: 2, player: timekeeper.playerOne, duration: 1, remaining: 60),
            Turn(movecount: 2, player: timekeeper.playerTwo, duration: 1, remaining: 60),
            Turn(movecount: 3, player: timekeeper.playerOne, duration: 3, remaining: 59),
            Turn(movecount: 3, player: timekeeper.playerTwo, duration: 3, remaining: 59)
        ]
        
        let expectedPlayTime: TimeInterval = moves.reduce(0) { $0 + $1.duration }

        // When:
        start(timekeeper)
        makeMoves(moves, with: timekeeper)
        fulfill(expectation, after: expectedPlayTime)

        // Wait for the expectation to fulfill.
        wait(for: [expectation], timeout: expectedPlayTime + 1)
    }
    
    func testUSDelayTimekeeping() {
        
        continueAfterFailure = false

        // Given:
        let thinkingTime = TimeInterval(60)

        let timeControl = TimeControl(stages: [USDelay(of: thinkingTime, delay: 2)])
        let timekeeper = Timekeeper(playerOne: timeControl, playerTwo: timeControl)
        let expectation = XCTestExpectation(description: "Timekeeper correctly starts and keeps track of the time when players take turns.")

        let moves = [
            Turn(movecount: 1, player: timekeeper.playerOne, duration: 2, remaining: 60),
            Turn(movecount: 1, player: timekeeper.playerTwo, duration: 2, remaining: 60),
            Turn(movecount: 2, player: timekeeper.playerOne, duration: 1, remaining: 60),
            Turn(movecount: 2, player: timekeeper.playerTwo, duration: 1, remaining: 60),
            Turn(movecount: 3, player: timekeeper.playerOne, duration: 3, remaining: 59),
            Turn(movecount: 3, player: timekeeper.playerTwo, duration: 3, remaining: 59)
        ]
        
        let expectedPlayTime: TimeInterval = moves.reduce(0) { $0 + $1.duration }

        // When:
        start(timekeeper)
        makeMoves(moves, with: timekeeper)
        fulfill(expectation, after: expectedPlayTime)

        // Wait for the expectation to fulfill.
        wait(for: [expectation], timeout: expectedPlayTime + 1)
    }
}

// MARK: - Private
extension TimeControlTests {
    private func makeMoves(_ moves: [Move], with timekeeper: Timekeeper) {
        
        var totalTime: TimeInterval = 0
        
        for move in moves {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + move.duration + totalTime) {
                try? timekeeper.switchTurn()
                XCTAssertEqual(move.player.remainingTime, move.remaining, accuracy: 0.1 * Double(move.movecount))
                print("Remaining: \(move.player.remainingTime)")
                print("Movecount: \(move.movecount)")
            }
            
            totalTime += move.duration
        }
    }
    
    private func start(_ timekeeper: Timekeeper) {
        do {
            try timekeeper.start()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fulfill(_ expectation: XCTestExpectation, after expectedTimeout: TimeInterval) {
        // Fulfilling the expectation here will mean that all moves were correctly timekept.
        DispatchQueue.main.asyncAfter(deadline: .now() + expectedTimeout) {
            expectation.fulfill()
        }
    }
}

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
        let increment: TimeInterval? = nil
        let delay: TimeInterval? = nil
        let remaining: TimeInterval
    }
    
    func testSuddenDeathTimekeeping() {
        
        let seconds = TimeInterval(60)
        
        let timeControl = TimeControl(of: seconds)
        let timekeeper = Timekeeper(playerOne: timeControl, playerTwo: timeControl)
        let expectation = XCTestExpectation(description: "Timekeeper stops when time is up for either player.")
        
        let moves = [
            Move(player: timekeeper.playerOne, move: 1, duration: 2, remaining: 58),
            Move(player: timekeeper.playerTwo, move: 1, duration: 2, remaining: 58),
            Move(player: timekeeper.playerOne, move: 2, duration: 1, remaining: 57),
            Move(player: timekeeper.playerTwo, move: 2, duration: 1, remaining: 57),
            Move(player: timekeeper.playerOne, move: 3, duration: 0.5, remaining: 56.5),
            Move(player: timekeeper.playerTwo, move: 3, duration: 0.5, remaining: 56.5)
        ]
        
        XCTAssertEqual(timekeeper.playerOne.remainingTime, seconds)
        XCTAssertEqual(timekeeper.playerTwo.remainingTime, seconds)
        
        var totalTime: TimeInterval = 0
        
        do {
            
            try timekeeper.start()
            
            for move in moves {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + move.duration + totalTime) {
                    
                    XCTAssertEqual(move.player.remainingTime, move.remaining, accuracy: 0.1)
                    print("Remaining: \(move.player.remainingTime)")
                    print("Movecount: \(move.move)")
                    try? timekeeper.switchTurn()
                }
                                
                totalTime += move.duration
            }
            
            print("All moves scheduled.")
            
            // If all moves were timekept correctly, fulfill the expectation.
//            expectation.fulfill()
            
        } catch {
            print("Error testing timekeeping.")
        }
        
        wait(for: [expectation], timeout: seconds + 1)
    }
    
    
    func testFischerTimekeeping() {
        
    }
    
    func testBronsteinTimekeeping() {
        
    }
    
    func testUSDelayTimekeeping() {
        
    }
}

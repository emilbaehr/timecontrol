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
    }
    
    func testSuddenDeathTimekeeping() {
        
        let seconds = TimeInterval(60)
        let timeControl = TimeControl(of: seconds)
        let timekeeper = Timekeeper(playerOne: timeControl, playerTwo: timeControl)
        let expectation = XCTestExpectation(description: "Timekeeper stops when time is up for either player.")
        
        let moves = [
            Move(player: timekeeper.playerOne, move: 1, duration: 2),
            Move(player: timekeeper.playerTwo, move: 1, duration: 2)
        ]
        
        XCTAssertEqual(timekeeper.playerOne.remainingTime, seconds)
        
        do {
            try timekeeper.start()
            
            for move in moves {
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                XCTAssertEqual(timekeeper.playerOne.remainingTime, 58, accuracy: 0.1)
                
                print(timekeeper.playerOne.remainingTime)
                
                expectation.fulfill()
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 60 + 1)
        
        XCTAssertEqual(2, 2)
    }
    
    
    func testFischerTimekeeping() {
        
    }
    
    func testBronsteinTimekeeping() {
        
    }
    
    func testUSDelayTimekeeping() {
        
    }
}

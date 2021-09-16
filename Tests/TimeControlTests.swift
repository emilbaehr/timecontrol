//
//  File.swift
//  
//
//  Created by Emil Christensen on 16/09/2021.
//

import TimeControl
import Foundation
import XCTest

class TimeControlTests: XCTestCase {
    
    func testTimekeeperStates() {
        
        let timeControl = TimeControl(of: 60)
        
        let timekeeper = Timekeeper(playerOne: timeControl, playerTwo: timeControl)
        
        let expectation = XCTestExpectation(description: "Timekeeper stops when time is up for either player.")
        
        do {
            try timekeeper.start()
        } catch {
            print(error.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 60 + 1)
        
        XCTAssertEqual(2, 2)
    }
    
}

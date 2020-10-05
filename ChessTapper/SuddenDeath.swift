//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

class SuddenDeath: TimeControl {

    var bookedTime: TimeInterval
    var increment: TimeInterval // For testing only, move to Fischer subclass.
    var delay: TimeInterval // For testing only, move to Bronstein subclass.
    
    required init(of seconds: TimeInterval) {
        self.bookedTime = seconds
        self.increment = TimeInterval(0)
        self.delay = TimeInterval(0)
    }
    
    func calculateRemainingTime(for player: Timekeeper.Player, with timing: Timekeeper.Timing) -> TimeInterval {
        
        let remainingTime = player.timeControl.bookedTime - Date().timeIntervalSince(timing.start) + Date().timeIntervalSince(timing.end) - player.timesheet.duration
        
        return remainingTime
    }
    
}

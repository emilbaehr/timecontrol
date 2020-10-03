//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

class SuddenDeath: TimeControl {

    var bookedTime: TimeInterval
    
    required init(of seconds: TimeInterval) {
        self.bookedTime = seconds
    }
    
    func calculateRemainingTime(for player: Timekeeper.Player, with timing: Timekeeper.Timing) -> TimeInterval {
        
        let remainingTime = bookedTime - (Date().timeIntervalSince(timing.start) + Date().timeIntervalSince(timing.end)) - player.timesheet.duration
        
        return remainingTime
    }
    
}

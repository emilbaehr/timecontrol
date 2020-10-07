//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

class Bronstein: TimeControl {

    var bookedTime: TimeInterval
    var increment: TimeInterval
    var delay: TimeInterval
    
    required init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval) {
        self.bookedTime = seconds
        self.increment = TimeInterval(increment)
        self.delay = TimeInterval(delay)
    }
    
    convenience init(of seconds: TimeInterval, delay: TimeInterval) {
        self.init(of: seconds, delay: delay, increment: TimeInterval(0))
    }
    
    func calculateRemainingTime(for player: Timekeeper.Player, with timing: Timekeeper.Timing) -> TimeInterval {
        
        // Remaining time = booked time - current timing - total duration:
        let remainingTime = player.timeControl.bookedTime - Date().timeIntervalSince(timing.start) + Date().timeIntervalSince(timing.end) - player.timesheet.duration
        
        return remainingTime
    }
    
}

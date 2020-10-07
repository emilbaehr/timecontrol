//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

class Fischer: TimeControl {

    var bookedTime: TimeInterval
    var increment: TimeInterval
    var delay: TimeInterval
    
    required init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval) {
        self.bookedTime = seconds
        self.increment = TimeInterval(increment)
        self.delay = TimeInterval(delay)
    }
    
    convenience init(of seconds: TimeInterval, increment: TimeInterval) {
        self.init(of: seconds, delay: TimeInterval(0), increment: increment)
    }
    
    func calculateRemainingTime(for player: Timekeeper.Player, with timing: Timekeeper.Timing) -> TimeInterval {
        
        // Remaining time = booked time - current timing - total duration + an increment:
        let remainingTime = player.timeControl.bookedTime - Date().timeIntervalSince(timing.start) + Date().timeIntervalSince(timing.end) - player.timesheet.duration + increment
        
        return remainingTime
    }
    
}

//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

class SuddenDeath: TimeControl {

    var bookedTime: TimeInterval
    var increment: TimeInterval
    var delay: TimeInterval
    var countdown: TimeInterval
    
    required init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval) {
        self.bookedTime = seconds
        self.increment = TimeInterval(increment)
        self.delay = TimeInterval(delay)
        self.countdown = TimeInterval(delay)
    }
    
    convenience init(of seconds: TimeInterval) {
        self.init(of: seconds, delay: TimeInterval(0), increment: TimeInterval(0))
    }
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with interval: DateInterval) -> TimeInterval {
        return remainingTime - interval.duration
    }
    
    func incrementAfter() -> TimeInterval {
        return TimeInterval(0)
    }
    
}

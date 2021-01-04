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
    var countdown: TimeInterval
    
    required init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval) {
        self.bookedTime = seconds
        self.increment = increment
        self.delay = delay
        self.countdown = delay
    }
    
    convenience init(of seconds: TimeInterval, increment: TimeInterval) {
        self.init(of: seconds, delay: .zero, increment: increment)
    }
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {
        return remainingTime - ongoing
    }
    
    func incrementAfter() -> TimeInterval {
        return increment
    }

}

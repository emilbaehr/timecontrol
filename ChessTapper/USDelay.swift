//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

class USDelay: TimeControl {

    var bookedTime: TimeInterval
    var increment: TimeInterval
    var delay: TimeInterval
    
    required init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval) {
        self.bookedTime = seconds
        self.increment = increment
        self.delay = delay
    }
    
    convenience init(of seconds: TimeInterval, delay: TimeInterval) {
        self.init(of: seconds, delay: delay, increment: TimeInterval(0))
    }
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {        
        return remainingTime - ongoing
    }
    
    func incrementAfter() -> TimeInterval {
        return .zero
    }
    
    func incrementBefore() -> TimeInterval {
        return .zero
    }
    
}

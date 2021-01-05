//
//  USDelay.swift
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
        self.init(of: seconds, delay: delay, increment: .zero)
    }
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {
        // Keep adding the ongoing time, as long as it's less than the Bronstein delay.
        // When the ongoing time gets larger than the Bronstein delay, the time will begin changing.
//        return remainingTime - ongoing + min(ongoing, delay)
        return remainingTime - ongoing
    }
    
    func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval {
        return .zero
    }
    
}

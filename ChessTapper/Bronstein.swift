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

    // Compute how much of the Bronstein delay was spent.
    var unusedTime: TimeInterval?
    
    required init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval) {
        self.bookedTime = seconds
        self.increment = increment
        self.delay = delay
    }
    
    convenience init(of seconds: TimeInterval, delay: TimeInterval) {
        self.init(of: seconds, delay: delay, increment: .zero)
    }
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {
        unusedTime = min(ongoing, delay)
        return remainingTime - ongoing
    }
    
    func incrementAfter() -> TimeInterval {
        guard let unusedTime = self.unusedTime else { return TimeInterval(0) }
        return unusedTime
    }
    
}

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
    
    required init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval) {
        self.bookedTime = seconds
        self.increment = TimeInterval(increment)
        self.delay = TimeInterval(delay)
    }
    
    convenience init(of seconds: TimeInterval) {
        self.init(of: seconds, delay: TimeInterval(0), increment: TimeInterval(0))
    }
    
    func calculateRemainingTime(for player: Timekeeper.Player, with timing: Timekeeper.Timing) -> TimeInterval {
        
        var remainingTime = player.remainingTime
        
        remainingTime -= 0.01
        
        return remainingTime
    }
    
}

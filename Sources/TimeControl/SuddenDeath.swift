//
//  SuddenDeath.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

class SuddenDeath: Stage {
    
    var moveCount: Int?
    var time: TimeInterval
    var increment: TimeInterval
    var delay: TimeInterval
    
    required init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval, moveCount: Int? = nil) {
        self.time = seconds
        self.increment = increment
        self.delay = delay
        self.moveCount = moveCount
    }
    
    convenience init(of seconds: TimeInterval) {
        self.init(of: seconds, delay: .zero, increment: .zero)
    }
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {
        return remainingTime - ongoing
    }
    
    func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval {
        return .zero
    }
    
}

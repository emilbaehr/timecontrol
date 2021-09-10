//
//  SuddenDeath.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

public struct SuddenDeath: Stage {
    
    public var moveCount: Int?
    public var time: TimeInterval
    public var increment: TimeInterval
    public var delay: TimeInterval
    
    public init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval, moveCount: Int? = nil) {
        self.time = seconds
        self.increment = increment
        self.delay = delay
        self.moveCount = moveCount
    }
    
    public init(of seconds: TimeInterval) {
        self.init(of: seconds, delay: .zero, increment: .zero)
    }
    
    public func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {
        return remainingTime - ongoing
    }
    
    public func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval {
        return .zero
    }
    
}

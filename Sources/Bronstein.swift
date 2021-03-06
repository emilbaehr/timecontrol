//
//  Bronstein.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

public struct Bronstein: Stage {
    
    public var type = StageType.bronstein
    
    public var moveCount: Int?
    public var time: TimeInterval
    public var increment: TimeInterval
    public var delay: TimeInterval
    
    public init(of seconds: TimeInterval, increment: TimeInterval, moveCount: Int? = nil) {
        self.moveCount = moveCount
        self.time = seconds
        self.increment = increment
        self.delay = 0
    }
    
    public func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval {
        return min(ongoing, increment)
    }
    
}

//
//  Bronstein.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

public class Bronstein: Stage {

    public convenience init(of seconds: TimeInterval, increment: TimeInterval, moveCount: Int? = nil) {
        self.init(seconds: seconds, moveCount: moveCount, increment: increment, delay: 0)
    }
    
    override public func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {
        return remainingTime - ongoing
    }
    
    override public func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval {
        return min(ongoing, increment)
    }
    
}

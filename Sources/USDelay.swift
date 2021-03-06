//
//  USDelay.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

public struct USDelay: Stage {
    
    public var type = StageType.usDelay
    
    public var moveCount: Int?
    public var time: TimeInterval
    public var increment: TimeInterval
    public var delay: TimeInterval
    
    public init(of seconds: TimeInterval, delay: TimeInterval, moveCount: Int? = nil) {
        self.moveCount = moveCount
        self.time = seconds
        self.increment = 0
        self.delay = delay
    }
    
}

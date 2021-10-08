//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

public struct TimeControl: Codable {
    
    public var stages: [Stage]
    public var stage: Stage
    
    public init(stages: [Stage]) {
        self.stages = stages
        self.stage = stages.first!
    }
    
    // A simple time control.
    public init(of seconds: TimeInterval) {
        self.stages = [SuddenDeath(of: seconds)]
        self.stage = stages.first!
    }
    
}

protocol HasIncrement {
    var increment: TimeInterval { get }
}

protocol HasDelay {
    var delay: TimeInterval { get }
}

public protocol StageBehaviour {
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval
    func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval
}

public class Stage: HasIncrement, HasDelay, Codable {
    
    public private(set) var moveCount: Int?
    public private(set) var time: TimeInterval
    public private(set) var increment: TimeInterval
    public private(set) var delay: TimeInterval
    
    public init(seconds: TimeInterval, moveCount: Int? = nil, increment: TimeInterval, delay: TimeInterval) {
        self.moveCount = moveCount
        self.time = seconds
        self.increment = increment
        self.delay = delay
    }
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {
        return remainingTime - ongoing
    }
    
    func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval {
        return 0
    }
}

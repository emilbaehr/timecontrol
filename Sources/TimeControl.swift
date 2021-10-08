//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

public struct TimeControl {
    
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

public protocol HasIncrement {
    var increment: TimeInterval { get }
}

public protocol HasDelay {
    var delay: TimeInterval { get }
}

public protocol Stage: HasIncrement, HasDelay, Codable {
    
    var moveCount: Int? { get }
    var time: TimeInterval { get }
    var increment: TimeInterval { get }
    var delay: TimeInterval { get }
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval
    
    func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval
}

extension Stage {
    
    public func encode(to encoder: Encoder) throws {
        
    }
    
}

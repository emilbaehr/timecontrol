//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

public struct TimeControl {
    
    public typealias Stage = TimeControlStage
    
    public let stages: [Stage]
    
    // Compute property for current stage?
    public var stage: Stage? {
        return stages.first
    }
    
    public init(stages: [Stage]) {
        self.stages = stages
    }
    
    // A simple time control.
    public init(of seconds: TimeInterval) {
        self.stages = [SuddenDeath(of: seconds)]
    }
    
}

public protocol TimeControlStage {
    
    var moveCount: Int? { get }         // For how many moves the stage is valid.
    var time: TimeInterval { get }      // Main thinking time.
    var increment: TimeInterval { get } // An increment that is added after the players turn.
                                        // Can be manipulated depending on the time control.
                                        // For Bronstein, for example, the increment can never be more than the user spent on their move.
    var delay: TimeInterval { get }     // A delay period before the timer starts counting down. Used in US Delay.
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval
    
    func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval
}

// MARK: - Default Implementation
extension TimeControl.Stage {
    
    public func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval {
        return 0
    }
    
}

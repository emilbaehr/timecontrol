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

// MARK: - Stage
public protocol Stage: Codable {
    
    var moveCount: Int? { get }
    var time: TimeInterval { get }
    var increment: TimeInterval { get }
    var delay: TimeInterval { get }
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval
    
    func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval
}

extension Stage {
    
    public func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {
        ongoing - remainingTime
    }
    
    public func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval {
        0
    }
    
}

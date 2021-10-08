//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

public struct TimeControl {
    
    public var stages: [AnyStage]
    public var stage: AnyStage
    
    public init(stages: [AnyStage]) {
        self.stages = stages
        self.stage = stages.first!
    }
    
    // A simple time control.
    public init(of seconds: TimeInterval) {
        self.stages = [AnyStage(SuddenDeath(of: seconds))]
        self.stage = stages.first!
    }
    
}

// MARK: - Stage
public struct AnyStage: Stage, Codable {

    public var moveCount: Int?
    public var time: TimeInterval
    public var increment: TimeInterval
    public var delay: TimeInterval

    init(_ base: Stage) {
        self.moveCount = base.moveCount
        self.time = base.time
        self.increment = base.increment
        self.delay = base.delay
    }
}

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

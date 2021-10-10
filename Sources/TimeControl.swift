//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

public struct TimeControl: Codable {
    
    public var stages: [AnyStage]
    public var stage: AnyStage
    
    public init(stages: [AnyStage]) {
        self.stages = stages
        self.stage = stages.first ?? AnyStage(stage: SuddenDeath(of: 60))
    }
    
    // A simple time control.
    public init(of seconds: TimeInterval) {
        self.stages = [AnyStage(stage: SuddenDeath(of: seconds))]
        self.stage = stages.first!
    }
    
}

// MARK: - Stage
public enum StageType: String, Codable {
    case noIncrement
    case bronstein
    case fischer
    case usDelay
    
    var metatype: Stage.Type {
        switch self {
        case .noIncrement:
            return SuddenDeath.self
        case .bronstein:
            return Bronstein.self
        case .fischer:
            return Fischer.self
        case .usDelay:
            return USDelay.self
        }
    }
}

public struct AnyStage: Codable {
    private var stage: Stage
    
    public var moveCount: Int? { stage.moveCount }
    public var time: TimeInterval { stage.time }
    public var increment: TimeInterval { stage.increment }
    public var delay: TimeInterval { stage.delay }
    
    public init(stage: Stage) {
        self.stage = stage
    }
    
    public func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {
        stage.calculateRemainingTime(for: remainingTime, with: ongoing)
    }
    
    public func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval {
        stage.calculateIncrement(for: ongoing)
    }
}

extension AnyStage {
    private enum CodingKeys: CodingKey {
        case type, stage
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(StageType.self, forKey: .type)
        self.stage = try type.metatype.init(from: container.superDecoder(forKey: .stage))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stage.type, forKey: .type)
        try stage.encode(to: container.superEncoder(forKey: .stage))
    }
}

public protocol Stage: Codable {
    
    var type: StageType { get }
    
    var moveCount: Int? { get }
    var time: TimeInterval { get }
    var increment: TimeInterval { get }
    var delay: TimeInterval { get }
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval
    
    func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval
}

extension Stage {
    
    public func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval {
        remainingTime - ongoing
    }
    
    public func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval {
        0
    }
    
}

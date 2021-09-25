//
//  Timesheet.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 10/10/2020.
//

import Foundation

public class Player {
    
    var name: String?
    
    internal(set) public var timeControl: TimeControl
    
    // Timesheet
    @Published internal(set) public var remainingTime: TimeInterval
    @Published internal(set) public var moves: Int
    internal(set) public var records = [Record]()
    
    // A time sheet record for a move.
    public struct Record {
        let move: Int                   // The move the time was recorded for.
        let timestamp: Date             // When the player tapped the clock. Or the game was stopped.
        let duration: TimeInterval      // Time spent on the move, without increment.
        let increment: TimeInterval     // The increment added after the move.
    }
    
    public init(timeControl: TimeControl, name: String? = nil) {
        self.name = name
        self.timeControl = timeControl
        self.remainingTime = timeControl.stage.time
        self.moves = 0
        self.records = []
    }
    
    // +1 moves so no moves are called "Move 0".
    public func record(timestamp: Date, duration: TimeInterval, increment: TimeInterval) {
        let record = Record(move: moves + 1,
                            timestamp: timestamp,
                            duration: duration,
                            increment: increment)
        records.append(record)
    }
    
    public static func ==(lhs: Player, rhs: Player) -> Bool {
        lhs === rhs
    }
    
}

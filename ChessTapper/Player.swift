//
//  Timesheet.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 10/10/2020.
//

import Foundation

@objc public class Player: NSObject {
    
    @objc dynamic var remainingTime: TimeInterval
    
    var timeControl: TimeControl
    
    var move: Int
    var moves = [Move]()
    
    // A time sheet record for a move.
    public struct Move {
        let move: Int
        let timestamp: Date // When the registration was made.
        let duration: TimeInterval // Time spent on the move.
        let increment: TimeInterval // The increment added after the move.
    }
    
    init(timeControl: TimeControl) {
        self.remainingTime = timeControl.bookedTime
        self.timeControl = timeControl
        self.move = 0
        self.moves = []
    }
    
    // Record the most recent move and add to players timesheet of moves.
    // TO-DO: Calculate duration of move. Is that including or excluding the increment? What about delay?
    func recordMove(from start: Date) {

        move += 1
        let record = Move(move: move, timestamp: start, duration: 0, increment: 0)
        moves.append(record)
        
        print("Move: \(record.move)")
        print("Timestamp: \(record.timestamp)")
    }
    
    func updateRemainingTime(with interval: DateInterval) {
        remainingTime = timeControl.calculateRemainingTime(for: remainingTime, with: interval)
    }
    
    // This function will be called after the players turn.
    func incrementAfter() {
        remainingTime += timeControl.incrementAfter()
    }
    
    // This function will be called at the beginning of the players turn.
    func incrementBefore() {
        remainingTime += timeControl.incrementBefore()
    }
    
    public static func ==(lhs: Player, rhs: Player) -> Bool {
        lhs === rhs
    }
    
}

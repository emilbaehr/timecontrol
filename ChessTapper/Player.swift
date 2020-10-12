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
    var moves = [Record]()
    
    // A time sheet record for a move.
    public struct Record {
        let timestamp: Date // Start of the record.
        let duration: TimeInterval // Time spent on the move.
        let increment: TimeInterval // The increment added after the move.
    }
    
    init(timeControl: TimeControl) {
        self.remainingTime = timeControl.bookedTime
        self.timeControl = timeControl
        self.move = 1
        self.moves = []
    }
    
    // Record the most recent move and add to players timesheet of moves.
    // TO-DO: Calculate duration of move. Is that including or excluding the increment? What about delay?
    func recordTime(from start: Date, to end: Date) {
        let interval = DateInterval(start: start, end: end)
        let record = Record(timestamp: start, duration: interval.duration, increment: 0)
        moves.append(record)
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

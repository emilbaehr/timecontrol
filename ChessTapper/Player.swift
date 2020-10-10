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
    
    var moves: Int
    var records = [Record]()
    
    // A time sheet record for a move.
    public struct Record {
        let timestamp: Date // When the registration was made
        let duration: TimeInterval // Time spent on the move
        let increment: TimeInterval // The increment added after the move
    }
    
    init(timeControl: TimeControl) {
        self.remainingTime = timeControl.bookedTime
        self.timeControl = timeControl
        self.moves = 0
        self.records = []
    }
    
//    // Record the most recent timing and add to players timesheet.
//    func recordTime(from start: Date, to end: Date) {
//        
//        let interval = DateInterval(start: start, end: end)
//        let record = Record(timestamp: interval.start, duration: interval.duration, increment: 0)
//        records.append(record)
//        
//    }
    
    func updateRemainingTime(with interval: DateInterval) {
        remainingTime = timeControl.calculateRemainingTime(for: remainingTime, with: interval)
    }
    
    // This function will be called after the players turn.
    func incrementAfter() {
//        TO-DO: A TimeControl function to return the increment / unused delay.
        remainingTime += timeControl.incrementAfter()
    }
    
    // This function will be called at the beginning of the players turn.
    func incrementBefore() {
//        TO-DO: A TimeControl function to return the increment / unused delay.
//        remainingTime += timeControl.delay
    }
    
    func resetCountdown() {
        timeControl.countdown = timeControl.delay
    }
    
    public static func ==(lhs: Player, rhs: Player) -> Bool {
        lhs === rhs
    }
    
}

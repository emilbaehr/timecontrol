//
//  Timesheet.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 10/10/2020.
//

import Foundation

@objc public class Player: NSObject {
    
    var name: String?
    
    @objc dynamic var remainingTime: TimeInterval
    
    var timeControl: TimeControl
    
    var moves: Int
    var records = [Record]()
    
    // A time sheet record for a move.
    public struct Record {
        let timestamp: Date // Start of the record.
        let duration: TimeInterval // Time spent on the move.
        let increment: TimeInterval // The increment added after the move.
    }
    
    init(timeControl: TimeControl, name: String? = nil) {
        self.name = name
        self.remainingTime = timeControl.bookedTime
        self.timeControl = timeControl
        self.moves = 0
        self.records = []
    }
    
    // This function will be called after the players turn.
    func incrementAfter() {
        remainingTime += timeControl.incrementAfter()
    }
    
    public static func ==(lhs: Player, rhs: Player) -> Bool {
        lhs === rhs
    }
    
}

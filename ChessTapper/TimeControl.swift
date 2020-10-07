//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

protocol TimeControl {
    
    var bookedTime: TimeInterval { get set }
    var increment: TimeInterval { get set }
    var delay: TimeInterval { get set }
    
    init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval)
    
    func calculateRemainingTime(for player: Timekeeper.Player, with timing: Timekeeper.Timing) -> TimeInterval
    
}

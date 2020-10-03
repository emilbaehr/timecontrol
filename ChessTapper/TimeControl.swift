//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

protocol TimeControl {
    
    var bookedTime: TimeInterval { get set }
    
    init(of seconds: TimeInterval)
    
    func calculateRemainingTime(for player: Timekeeper.Player, with timing: Timekeeper.Timing) -> TimeInterval
    
}

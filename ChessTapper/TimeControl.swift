//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

protocol TimeControl {
    
    var bookedTime: TimeInterval { get }
    var increment: TimeInterval { get }
    var delay: TimeInterval { get }
    var countdown: TimeInterval { get set }
    
    init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval)
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with interval: DateInterval) -> TimeInterval
    
    func incrementAfter() -> TimeInterval

    func incrementBefore() -> TimeInterval
    
}

//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

protocol TimeControl {
    
    var bookedTime: TimeInterval { get }
    var increment: TimeInterval { get } // An increment that is added after the players turn.
                                        // Can be manipulated depending on the time control.
                                        // For Bronstein, for example, the increment can never be more than the user spent on their move.
    var delay: TimeInterval { get }     // A delay period before the timer starts counting down. Used in US Delay.
    
    init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval)
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval
    
    func calculateIncrement(for ongoing: TimeInterval) -> TimeInterval
    
}

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
    
    init(of seconds: TimeInterval, delay: TimeInterval, increment: TimeInterval)
    
    func calculateRemainingTime(for remainingTime: TimeInterval, with ongoing: TimeInterval) -> TimeInterval
    
    func incrementAfter() -> TimeInterval
    
}

// Default implementation, such that it doesn't have to be explicitly written for each conforming class.
//extension TimeControl {
//
//    func incrementBefore() -> TimeInterval {
//        return TimeInterval(0)
//    }
//
//}

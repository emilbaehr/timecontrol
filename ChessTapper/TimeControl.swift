//
//  TimeControl.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/09/2020.
//

import Foundation

@objc class TimeControl: NSObject {
    
    let bookedTime: TimeInterval
    
    init(of seconds: TimeInterval) {
        self.bookedTime = seconds
    }
    
}

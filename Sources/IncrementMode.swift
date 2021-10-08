//
//  IncrementModes.swift
//  ChessTapper
//
//  Created by Emil Christensen on 31/07/2021.
//

import Foundation
 
public enum IncrementMode {
    case noIncrement
    case bronstein(increment: TimeInterval)
    case fischer(increment: TimeInterval)
    case usDelay(increment: TimeInterval)
}

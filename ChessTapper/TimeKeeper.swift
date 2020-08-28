//
//  TimeKeeper.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import Foundation

class TimeKeeper {

    private var timer: Timer?
    var whiteTime: TimeInterval
    var blackTime: TimeInterval
    var playerTurn: Color
    var gameType: GameType
    
    var isRunning: Bool {
        self.timer != nil
    }
    
    enum Color {
        case white
        case black
    }
    
    enum GameType {
        case fischer(increment: TimeInterval)
        case suddenDeath
    }
    
    init(time seconds: TimeInterval, gameType: GameType) {
        self.whiteTime = seconds
        self.blackTime = seconds
        self.playerTurn = .white
        self.gameType = gameType
    }
    
    func startTime(color: Color) {
        
    }
    
    func stopTime(color: Color) {
        
    }
    
    func switchTurn() {
        
    }
    
    func updateTime() {
        
    }
    
}

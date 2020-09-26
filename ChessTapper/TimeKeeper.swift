//
//  TimeKeeper.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import Foundation

@objc class TimeKeeper: NSObject {

    private var timer: Timer?
    
    @objc dynamic var whiteTime: TimeInterval
    @objc dynamic var blackTime: TimeInterval
    
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
        
        // Always begin as white.
        self.playerTurn = .white
        
        self.gameType = gameType
    }
    
    func startTime() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        switchTurn()
    }
    
    func pauseTime() {
        if (isRunning) {
            timer?.invalidate()
        }
    }
    
    func stopTime() {
        timer?.invalidate()
    }
    
    func switchTurn() {
        
        // Set playerTurn.
        if (playerTurn == .white) {
            playerTurn = .black
        } else {
            playerTurn = .white
        }
        
        // Do Fischer increment here.
    }
    
    @objc func updateTime() {
        
        switch playerTurn {
            case .white:
                whiteTime -= 1.0
            case .black:
                blackTime -= 1.0
        }
        
        if (whiteTime == 0 || blackTime == 0) {
            stopTime()
        }
        
        print("White: \(whiteTime)")
        print("Black: \(blackTime)")
    }
    
}

extension TimeInterval {

    func stringFromTimeInterval() -> String {

        // Get the time of the TimeInterval object, in seconds.
        let time = NSInteger(self)

        // Do time conversions.
        let seconds = time % 60
        let minutes = (time / 60) % 60
//        let hours = (time / 3600)

        // Format as String.
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}

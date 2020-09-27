//
//  Timekeeper.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import Foundation

@objc class Timekeeper: NSObject {

    private weak var timer: Timer?
    
    private var start: Date? // When the timer was started.
    
    var isRunning: Bool {
        self.timer != nil
    }
    
    @objc dynamic var whitePlayer: Player
    @objc dynamic var blackPlayer: Player
    
    public private(set) var playerInTurn: Player?
    public var playerOutOfTurn: Player? {
        guard let playerInTurn = self.playerInTurn else { return nil }
        return playerInTurn == self.whitePlayer ? self.blackPlayer : self.whitePlayer
    }
    
    enum State {
        case notStarted
        case running
        case paused
        case stopped
    }
    
    init(whitePlayerTime: TimeControl, blackPlayerTime: TimeControl) {
        self.whitePlayer = Player(timeControl: whitePlayerTime)
        self.blackPlayer = Player(timeControl: blackPlayerTime)
        
        // Always begin as white.
        self.playerInTurn = whitePlayer
    }
    
    func startTime() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
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
        if (playerInTurn == whitePlayer) {
            playerInTurn = blackPlayer
        } else {
            playerInTurn = whitePlayer
        }
        
    }
    
    @objc func updateTime() throws {
        
        if let player = playerInTurn {
            switch player {
                case whitePlayer:
                    whitePlayer.remainingTime -= 1.0
                case blackPlayer:
                    blackPlayer.remainingTime -= 1.0
                default:
                    throw Error.unknownPlayer
            }
        }
        
        if (whitePlayer.remainingTime == 0 || blackPlayer.remainingTime == 0) {
            stopTime()
        }
        
        print("White: \(whitePlayer.remainingTime)")
        print("Black: \(blackPlayer.remainingTime)")
    }
    
}

// MARK: -
extension Timekeeper {

    @objc public class Player: NSObject {
        
        @objc dynamic var remainingTime: TimeInterval

        public let timeControl: TimeControl
        
        init(timeControl: TimeControl) {
            self.timeControl = timeControl
            self.remainingTime = timeControl.bookedTime
        }
    }
    
}

// MARK: - Errors
extension Timekeeper {
    
    // Because we don't want to handle all the state and data clearing in conjunction with restarting a timekeeper from the beginning, we will throw an error. Just make a new Timekeeper.
    public enum Error: Swift.Error {
        case unknownPlayer
        case restartNotAllowed
    }
}

// MARK: -
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

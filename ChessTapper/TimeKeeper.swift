//
//  Timekeeper.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import Foundation

@objc class Timekeeper: NSObject, ObservableObject {

    private weak var timer: Timer?
    
    private var start: Date? // Start time of current timing.
    
    @objc dynamic var whitePlayer: Player
    @objc dynamic var blackPlayer: Player
    
    @objc dynamic public private(set) var playerInTurn: Player?
    public var playerOutOfTurn: Player? {
        guard let playerInTurn = self.playerInTurn else { return nil }
        return playerInTurn == self.whitePlayer ? self.blackPlayer : self.whitePlayer
    }
    
    @Published public private(set) var state: State

    enum State: Equatable {
        case notStarted
        case running
        case paused
        case stopped
    }
    
    init(whitePlayerTime: TimeControl, blackPlayerTime: TimeControl) {
        self.whitePlayer = Player(timeControl: whitePlayerTime)
        self.blackPlayer = Player(timeControl: blackPlayerTime)
        self.state = .notStarted
    }

    // Record the current timing and add to the ongoing duration for the player.
    fileprivate func recordTime(for player: Player, from start: Date, to now: Date) {
        player.duration += Date().timeIntervalSince(start) + Date().timeIntervalSince(now)
        self.timer?.invalidate()
        self.timer = nil
        self.start = nil
    }
    
    public func start(_ player: Player? = nil) throws {
        
        // If Timekeeper was stopped, do not allow restart.
        guard self.state != .stopped else { throw Error.restartNotAllowed }
        
        // If we're starting the player who's already running, just return.
        guard player == nil || player != self.playerInTurn || self.state == .paused else { return }
        guard player == nil || player == self.whitePlayer || player == self.blackPlayer else { throw Error.unknownPlayer }
        
        print("Starts?")
            
        // If a player is started, start it. Else, start the player in turn, or start white player.
        let nextPlayer = player ?? self.playerInTurn ?? self.whitePlayer
        
        let now = Date()
    
        if let previousPlayer = playerInTurn, let startOfCurrentTiming = start {
            recordTime(for: previousPlayer, from: startOfCurrentTiming, to: now)
        }
        
        self.start = now
        
        // The active player becomes the next player.
        self.playerInTurn = nextPlayer
        
        self.state = .running
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    public func pause() {

        guard self.state == .running else { return }
        guard let player = playerInTurn else { fatalError("No player in turn.") }
        guard let startOfCurrentTiming = self.start else { fatalError("Someone forgot to jot down the start of the current timing.") }

        let now = Date()
        recordTime(for: player, from: startOfCurrentTiming, to: now)
        
        // Just set the timer to nil.
        timer?.invalidate()
        self.timer = nil
        self.state = .paused
    }
    
    public func stop() {
        
        guard self.state != .stopped else { return }
        
        // Stop everything. Can't be restarted.
        timer?.invalidate()
        self.timer = nil
        self.playerInTurn = nil
        self.state = .stopped
    }
    
    // If clock isn't running, this will start the timer.
    public func switchTurn() throws {
        try start(playerOutOfTurn!)
//        playerInTurn = playerOutOfTurn
    }
    
    @objc func updateTime() {
        
        let now = Date()
        
        if let timing = self.start, let booked = playerInTurn?.timeControl.bookedTime, let duration = playerInTurn?.duration {
            let time = (booked - Date().timeIntervalSince(timing) + Date().timeIntervalSince(now) - duration)
            playerInTurn?.remainingTime = time
        }
        
        print("White: " + whitePlayer.remainingTime.stringFromTimeInterval())
        print("Black: " + blackPlayer.remainingTime.stringFromTimeInterval())
    }
    
}

// MARK: -
extension Timekeeper {

    @objc public class Player: NSObject {
        
        @objc dynamic var remainingTime: TimeInterval

        public let timeControl: TimeControl
        var duration: TimeInterval
        
        init(timeControl: TimeControl) {
            self.timeControl = timeControl
            self.remainingTime = timeControl.bookedTime
            self.duration = 0
        }
        
        public static func ==(lhs: Player, rhs: Player) -> Bool {
            lhs === rhs
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

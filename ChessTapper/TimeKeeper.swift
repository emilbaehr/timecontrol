//
//  Timekeeper.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import Foundation

@objc class Timekeeper: NSObject, ObservableObject {

    private var timer: Timer?
    
    private var start: Date? // Start time of current timing.
    private var countdown: TimeInterval?// The time at which the game might have been paused, used for delays.
//    private var delayBy: DateInterval?
    
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
    
    init(whitePlayer: TimeControl, blackPlayer: TimeControl) {
        self.whitePlayer = Player(timeControl: whitePlayer)
        self.blackPlayer = Player(timeControl: blackPlayer)
        self.state = .notStarted
    }
    
    public func start(_ player: Player? = nil) throws {
        
        // If Timekeeper was stopped, do not allow restart.
        guard state != .stopped else { throw Error.restartNotAllowed }
        
        // If we're starting the player who's already running, just return.
        guard player == nil || player != playerInTurn || state == .paused else { return }
        guard player == nil || player == whitePlayer || player == blackPlayer else { throw Error.unknownPlayer }
            
        // If a player is started, start it. Else, start the player in turn, or start white player.
        let nextPlayer = player ?? playerInTurn ?? whitePlayer
    
        // Record time on the player who was just in turn, before changing player.
        if let previousPlayer = playerInTurn {
            recordTime(for: previousPlayer)
            timer?.invalidate()
            timer = nil
            start = nil
        }
                        
        // The active player becomes the next player.
        playerInTurn = nextPlayer
        
        // Get the TimeControl's delay before next players turn, but only if the game was not paused
        // in which case, the timer should just use the ongoing countdown.
        if state != .paused {
            countdown = playerInTurn?.timeControl.delay
        }
                        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            
            let now = Date()
            self.start = now
            
            self.countdown! -= 0.01
            
            if let countdown = self.countdown, countdown <= 0 {
                print(countdown)
                self.timer?.invalidate()
                self.timer = nil
                self.startTimer(for: nextPlayer)
            }
            
        }
        
        self.state = .running
    }
    
    public func pause() {

        guard state == .running else { return }
        guard let player = playerInTurn else { fatalError("No player in turn.") }
        
        recordTime(for: player)
        
        // Just set the timer to nil.
        timer?.invalidate()
        timer = nil
        
        state = .paused
    }
    
    public func stop() {
        
        guard self.state != .stopped else { return }
        
        // Stop everything. Can't be restarted.
        timer?.invalidate()
        timer = nil
        playerInTurn = nil
        
        state = .stopped
    }
    
    public func switchTurn() throws {
        guard let nextPlayer = playerOutOfTurn else { return }
        try start(nextPlayer)
    }
    
// MARK: - Helpers
    
    @objc func updateTime() {
        
        if let startOfTiming = start, let player = playerInTurn {
            let timing = Timing(start: startOfTiming, end: Date())
            
            guard let time = playerInTurn?.timeControl.calculateRemainingTime(for: player, with: timing) else { return }
            
            // If the game was paused, don't add the TimeControl's increment.
            if state == .paused, let increment = playerInTurn?.timeControl.increment {
                playerInTurn?.remainingTime = time - increment
            } else {
                playerInTurn?.remainingTime = time
            }
        }

//        print("White: " + whitePlayer.remainingTime.stringFromTimeInterval())
//        print("Black: " + blackPlayer.remainingTime.stringFromTimeInterval())
    }
    
    // Record the current timing and add to the ongoing duration for the player.
    func recordTime(for player: Player) {
        player.timesheet.duration = player.timeControl.bookedTime - player.remainingTime
    }
    
    private func startTimer(for nextPlayer: Timekeeper.Player) {
        // TO-DO: Stop the timer and notify that game's finished when a player time becomes 0.
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            
            self.updateTime()
            if nextPlayer.remainingTime <= 0.00 {
                print("Time's up!")
                self.stop()
            }
            
        }
        timer?.tolerance = 0.01
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

// MARK: - Types
extension Timekeeper {
    
    struct Timing {
        var start: Date
        var end: Date
    }
    
}

extension Timekeeper {

    @objc public class Player: NSObject {
        
        public let timeControl: TimeControl
        
        @objc dynamic var remainingTime: TimeInterval
        
        var timesheet: Timesheet
        
        struct Timesheet {
            var duration: TimeInterval
        }
        
        init(timeControl: TimeControl) {
            self.timeControl = timeControl
            self.remainingTime = timeControl.bookedTime
            self.timesheet = Timesheet(duration: 0)
        }
        
        public static func ==(lhs: Player, rhs: Player) -> Bool {
            lhs === rhs
        }
        
    }
    
}

// MARK: - Formatting
extension TimeInterval {

    func stringFromTimeInterval() -> String {

        // TO-DO: Rounding.
        
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

//
//  Timekeeper.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import Foundation

@objc class Timekeeper: NSObject, ObservableObject {

    private var timer: Timer?
    
    private var start: Date?             // Start time of current timing.
    private var paused: Date?             // Start time of current timing.
    
    private var delay: TimeInterval?     // Time to delay. Could be observed by the UI to display the delay.
    
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
        case timesUp
    }
    
    init(whitePlayer: TimeControl, blackPlayer: TimeControl) {
        self.whitePlayer = Player(timeControl: whitePlayer, name: "White")
        self.blackPlayer = Player(timeControl: blackPlayer, name: "Black")
        self.state = .notStarted
    }
    
    public func start(_ player: Player) throws {
        
        // If Timekeeper was stopped, do not allow restart.
        guard state != .stopped || state != .timesUp else { throw Error.restartNotAllowed }
        

        // Clear timer, since it might be running on the previous player.
        self.timer?.invalidate()
        self.timer = nil
        
        // The active player becomes the next player.
        playerInTurn = player
        
        // Start time for current move (or resumed move).
        start = Date()
        
        // Used by timer loop to update remaining time.
        let remainingTime = player.remainingTime
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in

            let now = Date()
            guard let start = self.start else { return }
            
            self.delay = max(player.timeControl.delay - DateInterval(start: start, end: now).duration, 0)
            
            if self.delay == 0 {
                let interval = DateInterval(start: start, end: now)
                player.remainingTime = max(player.timeControl.calculateRemainingTime(for: remainingTime, with: interval.duration - player.timeControl.delay), 0)
            }

            // Notify when the time is up.
            if player.remainingTime == 0 {
                self.timer?.invalidate()
                self.timer = nil
                self.state = .timesUp
            }
            
        }
        
        self.state = .running
    }
    
    public func pause() {
        guard state == .running else { return }
        guard let player = playerInTurn else { return }
        
        // Get the ongoing time.
        guard let start = self.start else { return }
        let interval = DateInterval(start: start, end: Date())
        
        recordTime(for: player, duration: interval.duration, increment: 0)
        
        // Just set the timer to nil.
        timer?.invalidate()
        timer = nil
        
        state = .paused
    }
    
    public func stop() {
        guard self.state != .stopped else { return }
        guard let player = playerInTurn else { return }
        
        // Get the ongoing time.
        guard let start = self.start else { return }
        let interval = DateInterval(start: start, end: Date())
        
        let increment = player.timeControl.calculateIncrement(for: interval.duration)
        recordTime(for: player, duration: interval.duration, increment: increment)
        
        // Stop everything. Can't be restarted.
        timer?.invalidate()
        timer = nil
        playerInTurn = nil
        
        state = .stopped
    }
    
    public func switchTurn() throws {
        guard let previousPlayer = playerInTurn else { return }
        guard let nextPlayer = playerOutOfTurn else { return }
        
        // Get the ongoing time.
        guard let start = self.start else { return }
        let interval = DateInterval(start: start, end: Date())
        
        let increment = previousPlayer.timeControl.calculateIncrement(for: interval.duration)
        recordTime(for: previousPlayer, duration: interval.duration, increment: increment)
        
        // Only when switching turn.
        previousPlayer.remainingTime += increment
        previousPlayer.moves += 1
        
        // Re(set)
        delay = nextPlayer.timeControl.delay
                
        print("\(whitePlayer.name ?? "White") move: \(previousPlayer.moves), time: \(previousPlayer.remainingTime)")
        print("\(blackPlayer.name ?? "Black") move: \(nextPlayer.moves), time: \(nextPlayer.remainingTime)")
        
        try self.start(nextPlayer)
    }
    
}

// MARK: - Helpers

extension Timekeeper {
    
    func recordTime(for player: Player, duration: TimeInterval, increment: TimeInterval) {
        let now = Date()
        player.record(timestamp: now, duration: duration, increment: increment)
    }
    
}

// MARK: - Errors
extension Timekeeper {
    
    // Because we don't want to handle all the state and data clearing in conjunction with restarting a timekeeper from the beginning, we will throw an error. Just make a new Timekeeper.
    public enum Error: Swift.Error {
        case unknownPlayer
        case restartNotAllowed
        case noStartTime
    }
}

// MARK: - Formatting
extension TimeInterval {

    func stringFromTimeInterval() -> String {
        
        // Use the custom TimeIntervalFormatter.
        let formatter = TimeIntervalFormatter()
        guard let string = formatter.string(from: self) else { return "String couldn't be formatted." }
        
        return string
    }
    
}

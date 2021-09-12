//
//  Timekeeper.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import Foundation

@objc public class Timekeeper: NSObject, ObservableObject {

    private var timer: Timer?
    
    private var start: Date?            // Start time of current timing.
    private var delay: TimeInterval?    // A TimeInterval that represents the ongoing delay.
                                        // Could be observed by the UI to display the delay.
    
    @objc dynamic public var whitePlayer: Player
    @objc dynamic public var blackPlayer: Player
    
    @objc dynamic public private(set) var playerInTurn: Player?
    public var playerOutOfTurn: Player? {
        guard let playerInTurn = self.playerInTurn else { return nil }
        return playerInTurn == self.whitePlayer ? self.blackPlayer : self.whitePlayer
    }
    
    @Published public private(set) var state: State

    public enum State: Equatable {
        case notStarted
        case running
        case paused
        case stopped
        case timesUp
    }
    
    public init(whitePlayer: TimeControl, blackPlayer: TimeControl) {
        self.whitePlayer = Player(timeControl: whitePlayer, name: "White")
        self.blackPlayer = Player(timeControl: blackPlayer, name: "Black")
        self.state = .notStarted
    }
    
    public func start(_ player: Player? = nil) throws {
        
        // If Timekeeper was stopped, do not allow restart.
        guard state != .stopped || state != .timesUp else { throw Error.restartNotAllowed }
        
        // Clear timer, since it might be running on the previous player.
        self.timer?.invalidate()
        self.timer = nil
        
        // Let the next player be the player specified in the call to start. Else, start the player in turn, or start white player.
        let nextPlayer = player ?? playerInTurn ?? whitePlayer
        
        // The active player becomes the next player.
        playerInTurn = nextPlayer
        
        // Start time for current move (or resumed move).
        start = Date()
        
        // Set initial delay
        if state == .notStarted {
            delay = nextPlayer.timeControl.stage?.delay
        }
        
        // Used by timer loop to update remaining time.
        let remainingTime = nextPlayer.remainingTime
        let remainingDelay = delay ?? 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in

            let now = Date()
            guard let start = self.start else { return }
            
            self.delay = max(remainingDelay - DateInterval(start: start, end: now).duration, 0)
            
            if self.delay == 0 {
                let interval = DateInterval(start: start, end: now)
                nextPlayer.remainingTime = max(nextPlayer.timeControl.stage?.calculateRemainingTime(for: remainingTime, with: interval.duration - remainingDelay) ?? 0, 0)
            }

            // Notify when the time is up.
            if nextPlayer.remainingTime == 0 {
                self.timer?.invalidate()
                self.timer = nil
                self.state = .timesUp
            }
            
        }
        
        state = .running
    }
    
    public func pause() {
        guard state == .running else { return }

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
        guard let previousPlayer = playerInTurn else { return }
        guard let nextPlayer = playerOutOfTurn else { return }
        
        // Get the ongoing time.
        guard let start = self.start else { return }
        let now = Date()
        let interval = DateInterval(start: start, end: now)
        
        let increment = previousPlayer.timeControl.stage?.calculateIncrement(for: interval.duration)
        previousPlayer.record(timestamp: now, duration: interval.duration, increment: increment ?? 0)
        
        // Only when switching turn, we increment time and move count. Not when pausing / resuming.
        previousPlayer.remainingTime += increment ?? 0
        previousPlayer.moves += 1
        
        // TODO: Check if the current stage has a moveCount attached. Check if the current stage is still valid and change accordingly.
        
        // Re(set)
        delay = nextPlayer.timeControl.stage?.delay
                
//        printGame()
        
        try self.start(nextPlayer)
    }
    
}

// MARK: - Debugging

extension Timekeeper {
    
    func printGame() {
        print("\(whitePlayer.name ?? "Player 1")    move: \(whitePlayer.moves)    time: \(whitePlayer.remainingTime)")
        print("\(blackPlayer.name ?? "Player 2")    move: \(blackPlayer.moves)    time: \(blackPlayer.remainingTime)")
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

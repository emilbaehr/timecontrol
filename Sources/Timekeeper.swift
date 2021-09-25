//
//  Timekeeper.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import Foundation

public class Timekeeper: ObservableObject {

    private var timer: Timer?
    
    // Start time of current timing.
    private var start: Date?
    
    // A TimeInterval that represents the ongoing delay.
    // Could be observed by the UI to display the delay.
    @Published public private(set) var delay: TimeInterval?
    
    @Published public private(set) var playerOne: Player
    @Published public private(set) var playerTwo: Player
    @Published public private(set) var playerInTurn: Player?
    @Published public private(set) var state: State

    public var playerOutOfTurn: Player? {
        guard let playerInTurn = self.playerInTurn else { return nil }
        return playerInTurn == self.playerOne ? self.playerTwo : self.playerOne
    }
    
    public enum State {
        case notStarted
        case running
        case paused
        case stopped
        case timesUp
    }
    
    public init(playerOne: TimeControl, playerTwo: TimeControl) {
        self.playerOne = Player(timeControl: playerOne, name: "White")
        self.playerTwo = Player(timeControl: playerTwo, name: "Black")
        self.state = .notStarted
    }
    
    public func start(_ player: Player? = nil) throws {
        
        // If Timekeeper was stopped, do not allow restart.
        guard state != .stopped || state != .timesUp else { throw Error.restartNotAllowed }
        
        // Clear timer, since it might be running on the previous player.
        self.timer?.invalidate()
        self.timer = nil
        
        // Let the next player be the player specified in the call to start. Else, start the player in turn, or start white player.
        let nextPlayer = player ?? playerInTurn ?? playerOne
        
        // The active player becomes the next player.
        playerInTurn = nextPlayer
        
        // Start time for current move (or resumed move).
        start = Date()
        
        // Set initial delay
        if state == .notStarted {
            delay = nextPlayer.timeControl.stage.delay
        }
        
        // Used by timer loop to update remaining time.
        let remainingTime = nextPlayer.remainingTime
        let remainingDelay = delay ?? 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in

            let now = Date()
            guard let start = self.start else { return }
            
            self.delay = max(remainingDelay - DateInterval(start: start, end: now).duration, 0)
            
            if self.delay == 0 {
                
                // Only start computing the ongoing interval when the delay has run out.
                let interval = DateInterval(start: start, end: now)
                
                nextPlayer.remainingTime = max(nextPlayer.timeControl.stage.calculateRemainingTime(for: remainingTime,
                                                                                                   with: interval.duration - remainingDelay), 0)
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
        
        let increment = previousPlayer.timeControl.stage.calculateIncrement(for: interval.duration)
        previousPlayer.record(timestamp: now, duration: interval.duration, increment: increment )
        
        // Only when switching turn, we increment time and move count. Not when pausing / resuming.
        previousPlayer.remainingTime += increment
        previousPlayer.moves += 1
        
        // TODO: Check if the current stage has a moveCount attached. Check if the current stage is still valid and change accordingly.
        
        // Re(set)
        delay = nextPlayer.timeControl.stage.delay
                
//        printGame()
        
        try self.start(nextPlayer)
    }
    
}

// MARK: - Debugging

extension Timekeeper {
    
    func printGame() {
        print("\(playerOne.name ?? "Player 1")    move: \(playerOne.moves)    time: \(playerOne.remainingTime)")
        print("\(playerTwo.name ?? "Player 2")    move: \(playerTwo.moves)    time: \(playerTwo.remainingTime)")
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

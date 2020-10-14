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
    
    public func start(_ player: Player? = nil) throws {
        
        // If Timekeeper was stopped, do not allow restart.
        guard state != .stopped else { throw Error.restartNotAllowed }
        
        // If we're starting the player who's already running, just return.
        guard player == nil || player != playerInTurn || state == .paused else { return }
        guard player == nil || player == whitePlayer || player == blackPlayer else { throw Error.unknownPlayer }
        
        // Clear timer, since it might be running on the previous player.
        self.timer?.invalidate()
        self.timer = nil
        
        // Let the next player be the player specified in the call to start. Else, start the player in turn, or start white player.
        let nextPlayer = player ?? playerInTurn ?? whitePlayer
        
        // The active player becomes the next player.
        playerInTurn = nextPlayer
        
        start = Date()
        
        // The remaining time for the next player at the start of the timing. Used in calculating remaining time - ongoing duration.
        let remainingTime = nextPlayer.remainingTime
                
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            
            let now = Date()
            
            if let start = self.start {                                
                let interval = DateInterval(start: start, end: now)
                nextPlayer.remainingTime = max(nextPlayer.timeControl.calculateRemainingTime(for: remainingTime, with: interval.duration), 0)
            }

            // Notify when the time is up.
            if nextPlayer.remainingTime == 0 {
                self.timer?.invalidate()
                self.timer = nil
                self.state = .timesUp
            }
    
//            print("White: " + self.whitePlayer.remainingTime.stringFromTimeInterval())
//            print("Black: " + self.blackPlayer.remainingTime.stringFromTimeInterval())
        }
        
        self.state = .running
    }
    
    public func pause() {
        guard state == .running else { return }
        guard let player = playerInTurn, let start = self.start else { return }
                
        // Just set the timer to nil.
        timer?.invalidate()
        timer = nil
        
        state = .paused
    }
    
    public func stop() {
        
        guard self.state != .stopped else { return }
        guard let player = playerInTurn, let start = self.start else { return }
        
        // Stop everything. Can't be restarted.
        timer?.invalidate()
        timer = nil
        playerInTurn = nil
        
        state = .stopped
    }
    
    public func switchTurn() throws {
        guard let previousPlayer = playerInTurn else { return }
        guard let nextPlayer = playerOutOfTurn else { return }
        
        previousPlayer.moves += 1
        previousPlayer.incrementAfter()
        nextPlayer.incrementBefore()
        
        print("\(previousPlayer.name ?? "Previous player") move: \(previousPlayer.moves)")
        print("\(nextPlayer.name ?? "Next player") move: \(nextPlayer.moves)")
        
        try start(nextPlayer)
    }
    
}

// MARK: - Helpers

extension Timekeeper {
        
}

// MARK: - Errors
extension Timekeeper {
    
    // Because we don't want to handle all the state and data clearing in conjunction with restarting a timekeeper from the beginning, we will throw an error. Just make a new Timekeeper.
    public enum Error: Swift.Error {
        case unknownPlayer
        case restartNotAllowed
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

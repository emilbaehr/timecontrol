//
//  Timekeeper.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import Foundation

@objc class Timekeeper: NSObject, ObservableObject {

    private weak var timer: Timer?
    
    private var start: Date? // When the timer was started.
    
    @objc dynamic var whitePlayer: Player
    @objc dynamic var blackPlayer: Player
    
    public private(set) var playerInTurn: Player?
    public var playerOutOfTurn: Player? {
        guard let playerInTurn = self.playerInTurn else { return nil }
        return playerInTurn == self.whitePlayer ? self.blackPlayer : self.whitePlayer
    }
    
    @Published public private(set) var state: State

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
        self.state = .notStarted
    }
    
    public func start(player: Player) throws {
        guard self.state != .stopped else { throw Error.restartNotAllowed }
        
        // If we're starting the player who's already running, just return.
//        guard player != self.playerInTurn || self.state == .paused else { return }
        guard player == self.whitePlayer || player == self.blackPlayer else { throw Error.unknownPlayer }
        
        let now = Date()
        
        let nextPlayer = player
        
        self.start = now
        if nextPlayer != self.playerInTurn {
            self.playerInTurn = nextPlayer
        }
        
        if self.state != .running {
            self.state = .running
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    public func pause() {
        
        guard self.state == .running else { return }

        // Just set the timer to nil.
        timer?.invalidate()
        self.timer = nil
        
        // Leave player in turn.
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
    public func switchTurn() {
        playerInTurn = playerOutOfTurn
    }
    
    @objc func updateTime() {
        
        playerInTurn?.remainingTime = remainingTime(for: playerInTurn!)
        print("White: \(whitePlayer.remainingTime)")
        print("Black: \(blackPlayer.remainingTime)")
    }
    
    func remainingTime(for player: Player) -> TimeInterval {
//        return player.timeControl.bookedTime - Date().timeIntervalSince(start!)
        return player.remainingTime - 1.0
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

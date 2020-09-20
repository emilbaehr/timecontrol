//
//  ViewController.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import UIKit

class ClockViewController: UIViewController {

    var timeKeeper: TimeKeeper?
    
    let whiteClock = UIView()
    let blackClock = UIView()
    
    let whiteClockLabel = UILabel(frame: .zero)
    let blackClockLabel = UILabel(frame: .zero)
        
    var observers = [NSKeyValueObservation]()
    
    var clockConstraints = [NSLayoutConstraint]()
    
    override func loadView() {

        let rootView = UIView()
        rootView.backgroundColor = .systemPink
        
        whiteClock.backgroundColor = .systemGray
        blackClock.backgroundColor = .systemOrange
        whiteClock.translatesAutoresizingMaskIntoConstraints = false
        blackClock.translatesAutoresizingMaskIntoConstraints = false
        
        whiteClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        whiteClockLabel.textAlignment = .center
        whiteClockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        blackClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        blackClockLabel.textAlignment = .center
        blackClockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        whiteClock.addSubview(whiteClockLabel)
        blackClock.addSubview(blackClockLabel)
        
        rootView.addSubview(whiteClock)
        rootView.addSubview(blackClock)
        
        let whiteClockTap = UITapGestureRecognizer(target: self, action:  #selector(switchTurn(_:)))
        let blackClockTap = UITapGestureRecognizer(target: self, action:  #selector(switchTurn(_:)))
        whiteClock.addGestureRecognizer(whiteClockTap)
        blackClock.addGestureRecognizer(blackClockTap)
        whiteClock.isUserInteractionEnabled = true
        blackClock.isUserInteractionEnabled = true
        
        clockConstraints = [
            whiteClock.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            whiteClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            whiteClock.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            
            blackClock.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            blackClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            blackClock.topAnchor.constraint(equalTo: whiteClock.bottomAnchor)
        ]
        NSLayoutConstraint.activate(clockConstraints)

        let labelConstraints = [
            whiteClockLabel.widthAnchor.constraint(equalTo: whiteClock.widthAnchor),
            whiteClockLabel.centerXAnchor.constraint(equalTo: whiteClock.centerXAnchor),
            whiteClockLabel.centerYAnchor.constraint(equalTo: whiteClock.centerYAnchor),
            
            blackClockLabel.widthAnchor.constraint(equalTo: blackClock.widthAnchor),
            blackClockLabel.centerXAnchor.constraint(equalTo: blackClock.centerXAnchor),
            blackClockLabel.centerYAnchor.constraint(equalTo: blackClock.centerYAnchor),
        ]
        NSLayoutConstraint.activate(labelConstraints)
        
        self.view = rootView
    }
    
    override func viewDidLoad() {
        
        timeKeeper = TimeKeeper(time: 300, gameType: .suddenDeath)

        // Starting time should be done by user.
        timeKeeper?.startTime()
    
        observers = [
            timeKeeper!.observe(\.whiteTime, options: .new) { (tk, change) in
                self.whiteClockLabel.text = tk.whiteTime.stringFromTimeInterval()
            },
            timeKeeper!.observe(\.blackTime, options: .new) { (tk, change) in
                self.blackClockLabel.text = tk.blackTime.stringFromTimeInterval()
            }
        ]
    }
    
    @objc func switchTurn(_ sender: UITapGestureRecognizer) {
        
        let clockConstraintsWhite = [
            whiteClock.widthAnchor.constraint(equalTo: view.widthAnchor),
            whiteClock.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            whiteClock.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            blackClock.widthAnchor.constraint(equalTo: view.widthAnchor),
            blackClock.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7),
            blackClock.topAnchor.constraint(equalTo: whiteClock.bottomAnchor)
        ]
        
        NSLayoutConstraint.deactivate(clockConstraints)
        NSLayoutConstraint.activate(clockConstraintsWhite)
        
        print("Tapped!")
        timeKeeper?.switchTurn()
    }

}

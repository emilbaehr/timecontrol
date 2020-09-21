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
    var whiteTurnConstraints = [NSLayoutConstraint](), blackTurnConstraints = [NSLayoutConstraint](), notStartedConstraints = [NSLayoutConstraint]()
    
    fileprivate func layoutLabels() {
        let labelConstraints = [
            whiteClockLabel.widthAnchor.constraint(equalTo: whiteClock.widthAnchor),
            whiteClockLabel.centerXAnchor.constraint(equalTo: whiteClock.centerXAnchor),
            whiteClockLabel.centerYAnchor.constraint(equalTo: whiteClock.centerYAnchor),
            
            blackClockLabel.widthAnchor.constraint(equalTo: blackClock.widthAnchor),
            blackClockLabel.centerXAnchor.constraint(equalTo: blackClock.centerXAnchor),
            blackClockLabel.centerYAnchor.constraint(equalTo: blackClock.centerYAnchor),
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    override func loadView() {

        let rootView = UIView()
        rootView.backgroundColor = .black
        
        whiteClock.backgroundColor = .white
        blackClock.backgroundColor = .systemFill
        whiteClock.translatesAutoresizingMaskIntoConstraints = false
        blackClock.translatesAutoresizingMaskIntoConstraints = false
        
        whiteClock.clipsToBounds = true
        whiteClock.layer.cornerRadius = 32
        whiteClock.layer.cornerCurve = .continuous
        whiteClock.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        blackClock.clipsToBounds = true
        blackClock.layer.cornerRadius = 32
        blackClock.layer.cornerCurve = .continuous
        blackClock.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        
        whiteClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        whiteClockLabel.textAlignment = .center
        whiteClockLabel.textColor = .black
        whiteClockLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        whiteClockLabel.font = UIFont.boldSystemFont(ofSize: 48)
        whiteClockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        blackClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        blackClockLabel.textAlignment = .center
        blackClockLabel.font = UIFont.boldSystemFont(ofSize: 48)
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
        
        notStartedConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            blackClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ]
        NSLayoutConstraint.activate(notStartedConstraints)
        
        // Following constraint collections are for switching between white and black turn.
        whiteTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            blackClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8)
        ]
        
        blackTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            blackClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)
        ]
        
        clockConstraints = [
            whiteClock.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            whiteClock.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            
            blackClock.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            blackClock.topAnchor.constraint(equalTo: whiteClock.bottomAnchor)
        ]
        NSLayoutConstraint.activate(clockConstraints)

        layoutLabels()
        
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
        
        NSLayoutConstraint.deactivate(notStartedConstraints)
        
        if (timeKeeper?.playerTurn == .white) {
            NSLayoutConstraint.deactivate(blackTurnConstraints)
            NSLayoutConstraint.activate(whiteTurnConstraints)
        } else {
            NSLayoutConstraint.deactivate(whiteTurnConstraints)
            NSLayoutConstraint.activate(blackTurnConstraints)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        print("Tapped!")
        timeKeeper?.switchTurn()
    }

}

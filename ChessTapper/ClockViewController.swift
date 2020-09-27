//
//  ViewController.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import UIKit

class ClockViewController: UIViewController {

    var timeKeeper: Timekeeper?
    
    var didMakeFirstMove: Bool = false
    
    let whiteClock = UIView()
    let blackClock = UIView()
    
    let whiteClockLabel = UILabel(frame: .zero)
    let blackClockLabel = UILabel(frame: .zero)

    let whiteClockSecondaryLabel = UILabel(frame: .zero)
    let blackClockSecondaryLabel = UILabel(frame: .zero)
    
    let settingsButton = UIButton(type: .custom)
    @objc let pauseButton = UIButton(type: .custom)
        
    var observers = [NSKeyValueObservation]()
    
    var clockConstraints = [NSLayoutConstraint]()
    var whiteTurnConstraints = [NSLayoutConstraint](), blackTurnConstraints = [NSLayoutConstraint](), notStartedConstraints = [NSLayoutConstraint]()
    var settingsButtonConstraints = [NSLayoutConstraint]()
    var pauseButtonConstraints = [NSLayoutConstraint]()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func layoutLabels() {
        let labelConstraints = [
            whiteClockLabel.widthAnchor.constraint(equalTo: whiteClock.widthAnchor),
            whiteClockLabel.centerXAnchor.constraint(equalTo: whiteClock.centerXAnchor),
            whiteClockLabel.centerYAnchor.constraint(equalTo: whiteClock.centerYAnchor),
            
            blackClockLabel.widthAnchor.constraint(equalTo: blackClock.widthAnchor),
            blackClockLabel.centerXAnchor.constraint(equalTo: blackClock.centerXAnchor),
            blackClockLabel.centerYAnchor.constraint(equalTo: blackClock.centerYAnchor),
            
            whiteClockSecondaryLabel.widthAnchor.constraint(equalTo: whiteClock.widthAnchor),
            whiteClockSecondaryLabel.centerXAnchor.constraint(equalTo: whiteClock.centerXAnchor),
            whiteClockSecondaryLabel.bottomAnchor.constraint(equalTo: whiteClock.bottomAnchor, constant: -24),
            
            blackClockSecondaryLabel.widthAnchor.constraint(equalTo: blackClock.widthAnchor),
            blackClockSecondaryLabel.centerXAnchor.constraint(equalTo: blackClock.centerXAnchor),
            blackClockSecondaryLabel.topAnchor.constraint(equalTo: blackClock.topAnchor, constant: 24),
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    override func loadView() {

        let rootView = UIView()
        rootView.backgroundColor = .black
        
        whiteClock.backgroundColor = .white
        blackClock.backgroundColor = .secondarySystemGroupedBackground
        blackClock.overrideUserInterfaceStyle = .dark
        whiteClock.translatesAutoresizingMaskIntoConstraints = false
        blackClock.translatesAutoresizingMaskIntoConstraints = false
        
        whiteClock.clipsToBounds = true
        whiteClock.layer.cornerRadius = 24
        whiteClock.layer.cornerCurve = .continuous
//        whiteClock.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        
        blackClock.clipsToBounds = true
        blackClock.layer.cornerRadius = 24
        blackClock.layer.cornerCurve = .continuous
//        blackClock.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        whiteClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        whiteClockLabel.textAlignment = .center
        whiteClockLabel.translatesAutoresizingMaskIntoConstraints = false
        whiteClockLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 72, weight: .light)
        //        whiteClockLabel.font = .rounded(ofSize: 64, weight: .light)
        
        blackClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        blackClockLabel.textAlignment = .center
        blackClockLabel.textColor = .white
        blackClockLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        blackClockLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 72, weight: .light)
//        blackClockLabel.font = .rounded(ofSize: 64, weight: .light)

        blackClockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        blackClockSecondaryLabel.text = "Tap to Start"
        blackClockSecondaryLabel.textColor = .secondaryLabel
        blackClockSecondaryLabel.overrideUserInterfaceStyle = .dark
        blackClockSecondaryLabel.textAlignment = .center
        blackClockSecondaryLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        blackClockSecondaryLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        blackClockSecondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        whiteClockSecondaryLabel.text = "Waiting for Black"
        whiteClockSecondaryLabel.textColor = .secondaryLabel
        whiteClockSecondaryLabel.textAlignment = .center
        whiteClockSecondaryLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        whiteClockSecondaryLabel.translatesAutoresizingMaskIntoConstraints = false

        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        settingsButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        settingsButton.layer.cornerRadius = 22.0
        settingsButton.clipsToBounds = true
        settingsButton.backgroundColor = .secondarySystemGroupedBackground
        settingsButton.overrideUserInterfaceStyle = .dark
        settingsButton.tintColor = .label
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        let pauseButtonSymbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        pauseButton.setPreferredSymbolConfiguration(pauseButtonSymbolConfig, forImageIn: .normal)
        pauseButton.layer.cornerRadius = 22.0
        pauseButton.clipsToBounds = true
        pauseButton.overrideUserInterfaceStyle = .dark
        pauseButton.backgroundColor = .secondarySystemGroupedBackground
        pauseButton.tintColor = .label
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        let pauseTap = UITapGestureRecognizer(target: self, action: #selector(pauseButton(_:)))
        pauseButton.addGestureRecognizer(pauseTap)
        
        whiteClock.addSubview(whiteClockLabel)
        blackClock.addSubview(blackClockLabel)
        
        whiteClock.addSubview(whiteClockSecondaryLabel)
        blackClock.addSubview(blackClockSecondaryLabel)
        
        rootView.addSubview(blackClock)
        rootView.addSubview(whiteClock)
        rootView.addSubview(settingsButton)
        rootView.addSubview(pauseButton)
        
        let whiteClockTap = UITapGestureRecognizer(target: self, action:  #selector(switchTurn(_:)))
        let blackClockTap = UITapGestureRecognizer(target: self, action:  #selector(switchTurn(_:)))
        whiteClock.addGestureRecognizer(whiteClockTap)
        blackClock.addGestureRecognizer(blackClockTap)
        whiteClock.isUserInteractionEnabled = true
        blackClock.isUserInteractionEnabled = true
        
        notStartedConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5, constant: -82),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5, constant: -82)
        ]
        NSLayoutConstraint.activate(notStartedConstraints)
        
        // Following constraint collections are for switching between white and black turn.
        whiteTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.75, constant: -82),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.25, constant: -82)
        ]
        
        blackTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.25, constant: -82),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.75, constant: -82)
        ]
        
        clockConstraints = [
            blackClock.widthAnchor.constraint(equalTo: rootView.widthAnchor, constant: -16),
            blackClock.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 44),
            blackClock.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            
            whiteClock.widthAnchor.constraint(equalTo: rootView.widthAnchor, constant: -16),
            whiteClock.topAnchor.constraint(equalTo: blackClock.bottomAnchor, constant: 76),
            whiteClock.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
        ]
        NSLayoutConstraint.activate(clockConstraints)
        
        pauseButtonConstraints = [
            pauseButton.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            pauseButton.topAnchor.constraint(equalTo: blackClock.bottomAnchor, constant: 16),
            pauseButton.widthAnchor.constraint(equalToConstant: 44),
            pauseButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(pauseButtonConstraints)
        
        settingsButtonConstraints = [
            settingsButton.centerXAnchor.constraint(equalTo: rootView.centerXAnchor, constant: 68),
            settingsButton.topAnchor.constraint(equalTo: blackClock.bottomAnchor, constant: 16),
            settingsButton.widthAnchor.constraint(equalToConstant: 44),
            settingsButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(settingsButtonConstraints)

        layoutLabels()
        
        self.view = rootView
    }
    
    override func viewDidLoad() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        let timeControl = TimeControl(of: 300)
        timeKeeper = Timekeeper(whitePlayerTime: timeControl, blackPlayerTime: timeControl)
    
        observers = [
            timeKeeper!.observe(\.whitePlayer.remainingTime, options: .new) { (tk, change) in
                self.whiteClockLabel.text = tk.whitePlayer.remainingTime.stringFromTimeInterval()
            },
            timeKeeper!.observe(\.blackPlayer.remainingTime, options: .new) { (tk, change) in
                self.blackClockLabel.text = tk.blackPlayer.remainingTime.stringFromTimeInterval()
            }
        ]
    }
    
    @objc func switchTurn(_ sender: UITapGestureRecognizer) throws {
        
        NSLayoutConstraint.deactivate(notStartedConstraints)
        
        // Replace with states from Joachims Timekeeper class.
        switch (timeKeeper?.state) {
        // Case not started.
        case .notStarted:
            try timeKeeper?.start(player: timeKeeper!.playerInTurn!)
            NSLayoutConstraint.deactivate(blackTurnConstraints)
            NSLayoutConstraint.activate(whiteTurnConstraints)
            print("Hello?")
            whiteClockSecondaryLabel.text = "Your Turn"
            blackClockSecondaryLabel.isHidden = true
            break
            
        // Case running. Only switch turn if it is not the first move.
        case .running:
            if (didMakeFirstMove == false) {
                NSLayoutConstraint.deactivate(whiteTurnConstraints)
                NSLayoutConstraint.activate(blackTurnConstraints)
                try timeKeeper?.switchTurn()
                didMakeFirstMove = true
                blackClockSecondaryLabel.text = "Your Turn"
                blackClockSecondaryLabel.isHidden = false
                whiteClockSecondaryLabel.isHidden = true
                break
            }
            if (timeKeeper?.playerInTurn == timeKeeper?.whitePlayer) {
                NSLayoutConstraint.deactivate(whiteTurnConstraints)
                NSLayoutConstraint.activate(blackTurnConstraints)
                blackClockSecondaryLabel.text = "Your Turn"
                blackClockSecondaryLabel.isHidden = false
                whiteClockSecondaryLabel.isHidden = true
            } else {
                NSLayoutConstraint.deactivate(blackTurnConstraints)
                NSLayoutConstraint.activate(whiteTurnConstraints)
                whiteClockSecondaryLabel.text = "Your Turn"
                blackClockSecondaryLabel.isHidden = true
                whiteClockSecondaryLabel.isHidden = false
            }
            try timeKeeper?.switchTurn()
            
        case .paused: break
        case .stopped: break
        default: break
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func pauseButton(_ sender: UIButton) throws {
        
        if (timeKeeper?.state == .running) {
            timeKeeper?.pause()
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            NSLayoutConstraint.deactivate(whiteTurnConstraints)
            NSLayoutConstraint.deactivate(blackTurnConstraints)
            NSLayoutConstraint.activate(notStartedConstraints)
            blackClockSecondaryLabel.text = "Paused"
            whiteClockSecondaryLabel.text = "Paused"
            blackClockSecondaryLabel.isHidden = false
            whiteClockSecondaryLabel.isHidden = false
        } else {
            try timeKeeper?.start(player: timeKeeper!.playerInTurn!)
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
 
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

}

// MARK: - Extension for using SF Pro Rounded.
extension UIFont {
    class func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.monospacedDigitSystemFont(ofSize: size, weight: weight)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
}

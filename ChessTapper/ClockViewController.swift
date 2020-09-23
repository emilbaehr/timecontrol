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
    
    let settingsButton = UIImageView()
    let pauseButton = UIButton(type: .custom)
        
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
        whiteClock.layer.cornerRadius = 16
        whiteClock.layer.cornerCurve = .continuous
        whiteClock.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        
        blackClock.clipsToBounds = true
        blackClock.layer.cornerRadius = 16
        blackClock.layer.cornerCurve = .continuous
        blackClock.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        whiteClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        whiteClockLabel.textAlignment = .center
        whiteClockLabel.font = UIFont.boldSystemFont(ofSize: 48)
        whiteClockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        blackClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        blackClockLabel.textAlignment = .center
        blackClockLabel.textColor = .white
        blackClockLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        blackClockLabel.font = UIFont.boldSystemFont(ofSize: 48)
        blackClockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        settingsButton.image = UIImage(systemName: "gear")
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        settingsButton.preferredSymbolConfiguration = symbolConfig
        settingsButton.tintColor = .white
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        let pauseButtonSymbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        pauseButton.setPreferredSymbolConfiguration(pauseButtonSymbolConfig, forImageIn: .normal)
        pauseButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        pauseButton.layer.cornerRadius = 0.5 * pauseButton.bounds.size.width
        pauseButton.clipsToBounds = true
        pauseButton.backgroundColor = .systemRed
        pauseButton.tintColor = .white
//        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        whiteClock.addSubview(whiteClockLabel)
        blackClock.addSubview(blackClockLabel)
        
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
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5, constant: -64),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5, constant: -64)
        ]
        NSLayoutConstraint.activate(notStartedConstraints)
        
        // Following constraint collections are for switching between white and black turn.
        whiteTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.2, constant: -64),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.8, constant: -64)
        ]
        
        blackTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.8, constant: -64),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.2, constant: -64)
        ]
        
        clockConstraints = [
            blackClock.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            blackClock.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 64),
            
            whiteClock.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            whiteClock.topAnchor.constraint(equalTo: blackClock.bottomAnchor)
        ]
        NSLayoutConstraint.activate(clockConstraints)
        
        settingsButtonConstraints = [
            settingsButton.topAnchor.constraint(equalTo: whiteClock.bottomAnchor, constant: 24),
            settingsButton.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(settingsButtonConstraints)
        
        pauseButtonConstraints = [
            pauseButton.topAnchor.constraint(equalTo: whiteClock.bottomAnchor, constant: 24),
            pauseButton.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(pauseButtonConstraints)

        layoutLabels()
        
        self.view = rootView
    }
    
    override func viewDidLoad() {
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
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
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

}

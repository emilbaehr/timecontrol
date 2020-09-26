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
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    override func loadView() {

        let rootView = UIView()
        rootView.backgroundColor = .black
        
        whiteClock.backgroundColor = .white
        blackClock.backgroundColor = .black
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
        whiteClockLabel.translatesAutoresizingMaskIntoConstraints = false
        whiteClockLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 64, weight: .semibold)
        
        blackClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        blackClockLabel.textAlignment = .center
        blackClockLabel.textColor = .white
        blackClockLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        blackClockLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 64, weight: .semibold)

        blackClockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        settingsButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        settingsButton.layer.cornerRadius = 22.0
        settingsButton.layer.cornerCurve = .continuous
        settingsButton.clipsToBounds = true
        settingsButton.backgroundColor = .systemFill
        settingsButton.tintColor = .darkGray
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        let pauseButtonSymbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        pauseButton.setPreferredSymbolConfiguration(pauseButtonSymbolConfig, forImageIn: .normal)
        pauseButton.layer.cornerRadius = 22.0
        pauseButton.layer.cornerCurve = .continuous
        pauseButton.clipsToBounds = true
        pauseButton.backgroundColor = .systemGray
        pauseButton.tintColor = .secondaryLabel
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        let pauseTap = UITapGestureRecognizer(target: self, action: #selector(pauseButton(_:)))
        pauseButton.addGestureRecognizer(pauseTap)
        
        whiteClock.addSubview(whiteClockLabel)
        blackClock.addSubview(blackClockLabel)
        
        rootView.addSubview(blackClock)
        rootView.addSubview(whiteClock)
//        rootView.addSubview(settingsButton)
        rootView.addSubview(pauseButton)
        
        let whiteClockTap = UITapGestureRecognizer(target: self, action:  #selector(switchTurn(_:)))
        let blackClockTap = UITapGestureRecognizer(target: self, action:  #selector(switchTurn(_:)))
        whiteClock.addGestureRecognizer(whiteClockTap)
        blackClock.addGestureRecognizer(blackClockTap)
        whiteClock.isUserInteractionEnabled = true
        blackClock.isUserInteractionEnabled = true
        
        notStartedConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5, constant: 0),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5, constant: 0)
        ]
        NSLayoutConstraint.activate(notStartedConstraints)
        
        // Following constraint collections are for switching between white and black turn.
        whiteTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.33, constant: 0),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.67, constant: 0)
        ]
        
        blackTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.67, constant: 0),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.33, constant: 0)
        ]
        
        clockConstraints = [
            blackClock.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            blackClock.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 0),
            
            whiteClock.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            whiteClock.topAnchor.constraint(equalTo: blackClock.bottomAnchor)
        ]
        NSLayoutConstraint.activate(clockConstraints)
        
        settingsButtonConstraints = [
            settingsButton.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -24),
            settingsButton.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 24),
            settingsButton.widthAnchor.constraint(equalToConstant: 44),
            settingsButton.heightAnchor.constraint(equalToConstant: 44)
        ]
//        NSLayoutConstraint.activate(settingsButtonConstraints)
        
        pauseButtonConstraints = [
            pauseButton.centerYAnchor.constraint(equalTo: blackClock.bottomAnchor, constant: 0),
            pauseButton.centerXAnchor.constraint(equalTo: rootView.bottomAnchor, constant: 0),

//            pauseButton.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -24),
            pauseButton.widthAnchor.constraint(equalToConstant: 44),
            pauseButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(pauseButtonConstraints)

        layoutLabels()
        
        self.view = rootView
    }
    
    override func viewDidLoad() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        timeKeeper = TimeKeeper(time: 300, gameType: .suddenDeath)

        // Starting time should be done by user.
//        timeKeeper?.startTime()
    
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
        
        if (timeKeeper?.isRunning == false) {
            timeKeeper?.startTime()
        }
        
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
    
    @objc func pauseButton(_ sender: UIButton) {
        timeKeeper?.pauseTime()
        pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

}

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
        whiteClock.layer.cornerRadius = 16
        whiteClock.layer.cornerCurve = .continuous
//        whiteClock.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        
        blackClock.clipsToBounds = true
        blackClock.layer.cornerRadius = 16
        blackClock.layer.cornerCurve = .continuous
//        blackClock.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        whiteClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        whiteClockLabel.textAlignment = .center
        whiteClockLabel.translatesAutoresizingMaskIntoConstraints = false
        whiteClockLabel.font = .rounded(ofSize: 72, weight: .light)
        
        blackClockLabel.text = TimeInterval(300).stringFromTimeInterval()
        blackClockLabel.textAlignment = .center
        blackClockLabel.textColor = .white
        blackClockLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        blackClockLabel.font = .rounded(ofSize: 72, weight: .light)

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
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5, constant: -68),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5, constant: -68)
        ]
        NSLayoutConstraint.activate(notStartedConstraints)
        
        // Following constraint collections are for switching between white and black turn.
        whiteTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.25, constant: -68),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.75, constant: -68)
        ]
        
        blackTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.75, constant: -68),
            blackClock.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.25, constant: -68)
        ]
        
        clockConstraints = [
            blackClock.widthAnchor.constraint(equalTo: rootView.widthAnchor, constant: -32),
            blackClock.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 30),
            blackClock.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            
            whiteClock.widthAnchor.constraint(equalTo: rootView.widthAnchor, constant: -32),
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
        
        timeKeeper = TimeKeeper(time: 300, gameType: .suddenDeath)
    
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
        
        guard let state = timeKeeper?.isRunning else { return }
        
        // Replace with states from Joachims Timekeeper class.
        switch (state) {
        
            // Case not started.
            case false:
                timeKeeper?.startTime()
                NSLayoutConstraint.deactivate(blackTurnConstraints)
                NSLayoutConstraint.activate(whiteTurnConstraints)
                
            // Case running.
            case true:
                timeKeeper?.switchTurn()
                if (timeKeeper?.playerTurn == .white) {
                    NSLayoutConstraint.deactivate(blackTurnConstraints)
                    NSLayoutConstraint.activate(whiteTurnConstraints)
                } else {
                    NSLayoutConstraint.deactivate(whiteTurnConstraints)
                    NSLayoutConstraint.activate(blackTurnConstraints)
                }
                
            // Case paused.
        
            // Case stopped.
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    @objc func pauseButton(_ sender: UIButton) {
        
        if (timeKeeper?.isRunning == true) {
            timeKeeper?.pauseTime()
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            timeKeeper?.startTime()
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
 
    
// MARK: -
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

}


// MARK: -
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

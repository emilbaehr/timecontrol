//
//  ViewController.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import UIKit
import Combine

class ClockViewController: UIViewController {

    private var timeControl: TimeControl?
    private var timeKeeper: Timekeeper?
    
    // UI components.
    let whiteClock = UIView()
    let blackClock = UIView()
    let whiteClockLabel = UILabel(frame: .zero)
    let blackClockLabel = UILabel(frame: .zero)
    let whiteClockSecondaryLabel = UILabel(frame: .zero)
    let blackClockSecondaryLabel = UILabel(frame: .zero)
    let settingsButton = UIButton(type: .custom)
    let stopButton = UIButton(type: .custom)
    let pauseButton = UIButton(type: .custom)
        
    // Observers:
    private var observers = [NSKeyValueObservation]()
    private var cancellable: AnyCancellable?
    private var cancellable2: AnyCancellable?
    
    // Constraints:
    private var clockConstraints = [NSLayoutConstraint]()
    private var whiteTurnConstraints = [NSLayoutConstraint](), blackTurnConstraints = [NSLayoutConstraint](), notStartedConstraints = [NSLayoutConstraint]()
    private var settingsButtonConstraints = [NSLayoutConstraint](), pauseButtonConstraints = [NSLayoutConstraint](), stopButtonConstraints = [NSLayoutConstraint]()
    
    override func loadView() {

        let rootView = UIView()
        rootView.backgroundColor = .black
        
        timeControl = TimeControl(of: 300)
        
        if let timeControl = self.timeControl {
            timeKeeper = Timekeeper(whitePlayerTime: timeControl, blackPlayerTime: timeControl)
        }
        
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
        
        whiteClockLabel.text = timeKeeper?.whitePlayer.remainingTime.stringFromTimeInterval()
        whiteClockLabel.textAlignment = .center
        whiteClockLabel.translatesAutoresizingMaskIntoConstraints = false
        whiteClockLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 72, weight: .light)
        
        blackClockLabel.text = timeKeeper?.blackPlayer.remainingTime.stringFromTimeInterval()
        blackClockLabel.textAlignment = .center
        blackClockLabel.textColor = .white
        blackClockLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        blackClockLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 72, weight: .light)

        blackClockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        blackClockSecondaryLabel.textColor = .secondaryLabel
        blackClockSecondaryLabel.overrideUserInterfaceStyle = .dark
        blackClockSecondaryLabel.textAlignment = .center
        blackClockSecondaryLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        blackClockSecondaryLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        blackClockSecondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        whiteClockSecondaryLabel.textColor = .secondaryLabel
        whiteClockSecondaryLabel.overrideUserInterfaceStyle = .light
        whiteClockSecondaryLabel.textAlignment = .center
        whiteClockSecondaryLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        whiteClockSecondaryLabel.translatesAutoresizingMaskIntoConstraints = false

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingsButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        settingsButton.layer.cornerRadius = 22.0
        settingsButton.clipsToBounds = true
        settingsButton.backgroundColor = .secondarySystemGroupedBackground
        settingsButton.overrideUserInterfaceStyle = .dark
        settingsButton.tintColor = .label
        settingsButton.translatesAutoresizingMaskIntoConstraints = false

        stopButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        stopButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        stopButton.layer.cornerRadius = 22.0
        stopButton.clipsToBounds = true
        stopButton.backgroundColor = .secondarySystemGroupedBackground
        stopButton.overrideUserInterfaceStyle = .dark
        stopButton.tintColor = .label
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        let stopTap = UITapGestureRecognizer(target: self, action: #selector(stopButton(_:)))
        stopButton.addGestureRecognizer(stopTap)
        
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        pauseButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
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
        rootView.addSubview(stopButton)
        rootView.addSubview(pauseButton)
        
        let whiteClockTap = UITapGestureRecognizer(target: self, action:  #selector(switchTurn(_:)))
        let blackClockTap = UITapGestureRecognizer(target: self, action:  #selector(switchTurn(_:)))
        whiteClock.addGestureRecognizer(whiteClockTap)
        blackClock.addGestureRecognizer(blackClockTap)
        whiteClock.isUserInteractionEnabled = true
        blackClock.isUserInteractionEnabled = true
        
        notStartedConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -46),
            blackClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -46)
        ]
        NSLayoutConstraint.activate(notStartedConstraints)
        
        whiteTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.67, constant: -46),
            blackClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.33, constant: -46)
        ]
        
        blackTurnConstraints = [
            whiteClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.33, constant: -46),
            blackClock.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.67, constant: -46)
        ]
        
        clockConstraints = [
            blackClock.widthAnchor.constraint(equalTo: rootView.widthAnchor, constant: -16),
            blackClock.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor, constant: 8),
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
        
        stopButtonConstraints = [
            stopButton.centerXAnchor.constraint(equalTo: rootView.centerXAnchor, constant: -68),
            stopButton.topAnchor.constraint(equalTo: blackClock.bottomAnchor, constant: 16),
            stopButton.widthAnchor.constraint(equalToConstant: 44),
            stopButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(stopButtonConstraints)
        
        settingsButtonConstraints = [
            settingsButton.centerXAnchor.constraint(equalTo: rootView.centerXAnchor, constant: 68),
            settingsButton.topAnchor.constraint(equalTo: blackClock.bottomAnchor, constant: 16),
            settingsButton.widthAnchor.constraint(equalToConstant: 44),
            settingsButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(settingsButtonConstraints)

        layoutLabels()
        
        self.view = rootView
        self.view.layoutIfNeeded()
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
    
    private func render(_ state: Timekeeper.State) {
        
            switch state {
            case .notStarted, .stopped:
                print("Not Started.")
                blackClockSecondaryLabel.text = "Tap to Start"
                whiteClockSecondaryLabel.text = "Waiting for Black"
                
                blackClockSecondaryLabel.isHidden = false
                whiteClockSecondaryLabel.isHidden = false
                
                pauseButton.isEnabled = false
                stopButton.isEnabled = false
                
                break
                
            case .running:
                print("Running.")
                NSLayoutConstraint.deactivate(notStartedConstraints)
                pauseButton.isEnabled = true
                
                if (timeKeeper?.playerInTurn == timeKeeper?.whitePlayer) {
                    print("White!")
                    NSLayoutConstraint.deactivate(blackTurnConstraints)
                    NSLayoutConstraint.activate(whiteTurnConstraints)
                    whiteClockSecondaryLabel.text = "Your Turn"
                    whiteClockSecondaryLabel.isHidden = false
                    blackClockSecondaryLabel.isHidden = true
                } else {
                    print("Black!")
                    NSLayoutConstraint.deactivate(whiteTurnConstraints)
                    NSLayoutConstraint.activate(blackTurnConstraints)
                    blackClockSecondaryLabel.text = "Your Turn"
                    blackClockSecondaryLabel.isHidden = false
                    whiteClockSecondaryLabel.isHidden = true
                }
                
                settingsButton.isHidden = true
                stopButton.isHidden = true
                pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                break
                
            case .paused:
                print("Paused.")
                
                NSLayoutConstraint.deactivate(whiteTurnConstraints)
                NSLayoutConstraint.deactivate(blackTurnConstraints)
                NSLayoutConstraint.activate(notStartedConstraints)
                
                pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                
                blackClockSecondaryLabel.text = "Paused"
                whiteClockSecondaryLabel.text = "Paused"
                blackClockSecondaryLabel.isHidden = false
                whiteClockSecondaryLabel.isHidden = false
                
                settingsButton.isHidden = false
                stopButton.isHidden = false
                stopButton.isEnabled = true
                pauseButton.isEnabled = true
                break
            }
        
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    
    override func viewDidLoad() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        observeTimekeeper()
    }
    
    @objc func switchTurn(_ sender: UITapGestureRecognizer) throws {
        if timeKeeper?.state == .notStarted {
            try timeKeeper?.start(timeKeeper!.playerInTurn!)
        } else {
            timeKeeper?.switchTurn()
        }
    }
    
    @objc func pauseButton(_ sender: UIButton) throws {
        if timeKeeper?.state == .paused {
            try timeKeeper?.start(timeKeeper!.playerInTurn!)
        } else {
            timeKeeper?.pause()
        }
    }
    
    @objc func stopButton(_ sender: UIButton) {
//        if timeKeeper?.state == .paused {
//            do {
//                try timeKeeper?.restart()
//            } catch {
//                print(error)
//            }
//        }

        if timeKeeper?.state == .paused {
            timeKeeper?.stop()

            // Do some data clearing. Not sure if this should be build into the Timekeeper, though.
            if let whiteBooked = timeKeeper?.whitePlayer.timeControl.bookedTime, let blackBooked = timeKeeper?.whitePlayer.timeControl.bookedTime {
                timeKeeper?.whitePlayer.remainingTime = whiteBooked
                timeKeeper?.blackPlayer.remainingTime = blackBooked
            }

            guard let tC = self.timeControl else { return }
            print("Hello?")
            timeKeeper = Timekeeper(whitePlayerTime: tC, blackPlayerTime: tC)
            
            observeTimekeeper()
        }
    }

    fileprivate func observeTimekeeper() {
        cancellable = timeKeeper?.$state.sink { [weak self] state in
            self?.render(state)
        }
        
        observers = [
            timeKeeper!.observe(\.whitePlayer.remainingTime, options: .new) { (tk, change) in
                self.whiteClockLabel.text = tk.whitePlayer.remainingTime.stringFromTimeInterval()
            },
            timeKeeper!.observe(\.blackPlayer.remainingTime, options: .new) { (tk, change) in
                self.blackClockLabel.text = tk.blackPlayer.remainingTime.stringFromTimeInterval()
            },
            timeKeeper!.observe(\.playerInTurn, options: .new) { (tk, change) in
                print(change)
                self.render((self.timeKeeper?.state)!)
            }
        ]
    }
 
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
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

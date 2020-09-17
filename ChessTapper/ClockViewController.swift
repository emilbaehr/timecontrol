//
//  ViewController.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import UIKit

class ClockViewController: UIViewController {

    var timeKeeper: TimeKeeper?
    
    let clock1 = UIView()
    let clock2 = UIView()
    
    let label1 = UILabel(frame: .zero)
    let label2 = UILabel(frame: .zero)
//    let button = UIButton(type: .system)
        
    var observers = [NSKeyValueObservation]()
    
    override func loadView() {

        let rootView = UIView()
        rootView.backgroundColor = .systemPink
        
        clock1.backgroundColor = .systemGray
        clock2.backgroundColor = .systemOrange
        clock1.translatesAutoresizingMaskIntoConstraints = false
        clock2.translatesAutoresizingMaskIntoConstraints = false
        
        label1.text = TimeInterval(300).stringFromTimeInterval()
        label1.textAlignment = .center
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        label2.text = TimeInterval(300).stringFromTimeInterval()
        label2.textAlignment = .center
        label2.translatesAutoresizingMaskIntoConstraints = false
        
        clock1.addSubview(label1)
        clock2.addSubview(label2)
        
        rootView.addSubview(clock1)
        rootView.addSubview(clock2)
        
        let clock1Tap = UITapGestureRecognizer(target: self, action:  #selector(switchTurn(_:)))
        let clock2Tap = UITapGestureRecognizer(target: self, action:  #selector(switchTurn(_:)))
        clock1.addGestureRecognizer(clock1Tap)
        clock2.addGestureRecognizer(clock2Tap)
        clock1.isUserInteractionEnabled = true
        clock2.isUserInteractionEnabled = true
        
//        button.setTitle("Switch", for: .normal)
//        clock1.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(switchTurn), for: .touchUpInside)
        
        let constraints = [
            clock1.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            clock1.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            clock1.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            
            clock2.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            clock2.heightAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            clock2.topAnchor.constraint(equalTo: clock1.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        let labelConstraints = [
            label1.widthAnchor.constraint(equalTo: clock1.widthAnchor),
            label1.centerXAnchor.constraint(equalTo: clock1.centerXAnchor),
            label1.centerYAnchor.constraint(equalTo: clock1.centerYAnchor),
            
            label2.widthAnchor.constraint(equalTo: clock2.widthAnchor),
            label2.centerXAnchor.constraint(equalTo: clock2.centerXAnchor),
            label2.centerYAnchor.constraint(equalTo: clock2.centerYAnchor),
            
//            button.centerXAnchor.constraint(equalTo: clock1.centerXAnchor),
//            button.topAnchor.constraint(equalTo: label1.bottomAnchor)
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
                self.label1.text = tk.whiteTime.stringFromTimeInterval()
            },
            timeKeeper!.observe(\.blackTime, options: .new) { (tk, change) in
                self.label2.text = tk.blackTime.stringFromTimeInterval()
            }
        ]
    }
    
    @objc func switchTurn(_ sender: UITapGestureRecognizer) {
        print("Tapped!")
        timeKeeper?.switchTurn()
    }

}

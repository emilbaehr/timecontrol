//
//  ViewController.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 27/08/2020.
//

import UIKit

class ClockViewController: UIViewController {

    override func loadView() {
        let rootView = UIView()
        rootView.backgroundColor = .systemPink
        
        let clock1 = UIView()
        clock1.backgroundColor = .systemBlue
        
        let clock2 = UIView()
        clock2.backgroundColor = .systemOrange
        
        rootView.addSubview(clock1)
        rootView.addSubview(clock2)
        
        clock1.translatesAutoresizingMaskIntoConstraints = false
        clock2.translatesAutoresizingMaskIntoConstraints = false
        
        let label1 = UILabel(frame: .zero)
        label1.text = "0:00"
        label1.textAlignment = .center
        clock1.addSubview(label1)
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        let label2 = UILabel(frame: .zero)
        label2.text = "0:00"
        label2.textAlignment = .center
        clock2.addSubview(label2)
        label2.translatesAutoresizingMaskIntoConstraints = false

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
            label2.centerYAnchor.constraint(equalTo: clock2.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
        
        self.view = rootView
        
        let timeKeeper1 = TimeKeeper(time: 60, gameType: .suddenDeath)
        
        timeKeeper1.startTime(color: .white)
    }

}


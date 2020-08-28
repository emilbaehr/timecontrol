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
        rootView.addSubview(clock1)
        
        clock1.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            clock1.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            clock1.heightAnchor.constraint(equalTo: rootView.heightAnchor),
            clock1.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            clock1.centerYAnchor.constraint(equalTo: rootView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        self.view = rootView
    }

}


//
//  GameConfigurationViewController.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 14/10/2020.
//

import Foundation
import UIKit

class GameConfigurationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    
    weak var delegate: GameConfigurationDelegate?
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    var navBar = UINavigationBar(frame: .zero)
    
    var selectedTimeControl: TimeControl?
    
    let timeControls: Array<TimeControl> = [
        SuddenDeath(of: 300),
        SuddenDeath(of: 600),
        Bronstein(of: 300, delay: 5),
        Bronstein(of: 600, delay: 3),
        Fischer(of: 300, increment: 5),
        Fischer(of: 600, increment: 3)
    ]
    
    override func loadView() {
        super.loadView()
        
        // Add Nav Bar.
        self.view.addSubview(navBar)
        navigationItem.title = "Time Control"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(done))
        navBar.setItems ([navigationItem], animated: false)
        
        navBar.delegate = self
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                
        // Add Table View.
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0,bottom: 0, right: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.bringSubviewToFront(navBar)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeControls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String("TimeControl \(indexPath.row)")
        return cell
    }
    
    @objc func done() {
        
        if let timeControl = selectedTimeControl {
            let timekeeper = Timekeeper(whitePlayer: timeControl, blackPlayer: timeControl)
            delegate?.finishedConfiguringTimekeeper(timekeeper)
        }
        
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTimeControl = timeControls[indexPath.row]
        print("Selected row \(indexPath.row).")
    }
    
}

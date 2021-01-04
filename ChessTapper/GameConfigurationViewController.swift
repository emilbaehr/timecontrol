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
    var currentIndex: IndexPath?
    
    struct TimeControlPresentation {
        var name: String
        var timeControl: TimeControl
    }
    
    let timeControls: [Int : TimeControlPresentation] = [
        0 : TimeControlPresentation(name: "5 min", timeControl: SuddenDeath(of: 300)),
        1 : TimeControlPresentation(name: "10 min", timeControl: SuddenDeath(of: 300)),
        2 : TimeControlPresentation(name: "Fischer 5 | 5", timeControl: Fischer(of: 300, increment: 5)),
        3 : TimeControlPresentation(name: "Fischer 10 | 3", timeControl: Fischer(of: 600, increment: 3)),
        4 : TimeControlPresentation(name: "Bronstein 5 | 5", timeControl: Bronstein(of: 300, delay: 5)),
        5 : TimeControlPresentation(name: "Bronstein 10 | 3", timeControl: Bronstein(of: 600, delay: 3)),
        6 : TimeControlPresentation(name: "US Delay 5 | 5", timeControl: USDelay(of: 300, delay: 5)),
        7 : TimeControlPresentation(name: "US Delay 10 | 3", timeControl: USDelay(of: 600, delay: 3))
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
    
    override func viewWillAppear(_ animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: currentIndex, animated: false, scrollPosition: .none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeControls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
        let timeControl = timeControls[indexPath.row]
        cell.textLabel?.text = (timeControl?.name)
        cell.selectionStyle = .none
        
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
        
        // Persist it.
        currentIndex = indexPath
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        selectedTimeControl = timeControls[indexPath.row]?.timeControl
        print("Selected row \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
}

//
//  GameConfigurationViewController.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 14/10/2020.
//

import Foundation
import UIKit

class GameConfigurationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: GameConfigurationDelegate?
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
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
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeControls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String("TimeControl \(indexPath.row)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeControl = timeControls[indexPath.row]
        let timekeeper = Timekeeper(whitePlayer: timeControl, blackPlayer: timeControl)
        print("Selected row \(indexPath.row).")
        delegate?.finishedConfiguringTimekeeper(timekeeper)
    }
    
}

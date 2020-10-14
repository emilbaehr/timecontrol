//
//  GameConfigurationViewController.swift
//  ChessTapper
//
//  Created by Emil Malthe Bæhr Christensen on 14/10/2020.
//

import Foundation
import UIKit

class GameConfigurationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    let gameModes = [
        "5|3"   : 10,
        "10|3"  : 10,
        "5|0"  : 10,
        "10|0"  : 10
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameModes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let gameModesList = Array(gameModes.keys)
        cell.textLabel?.text = String("\(gameModesList[indexPath.row]) \(gameModes[gameModesList[indexPath.row]])")
        return cell
    }
    
}

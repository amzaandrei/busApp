//
//  ViewController.swift
//  ratbvApp
//
//  Created by Andrew on 1/4/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit

class busesController: UITableViewController {

    let buses = ["36", "8"]
    let urlArr = ["https://api.myjson.com/bins/m0b4j", "https://api.myjson.com/bins/19bsql"]
    let cellId = "cellId"
    
    var connectivityHandler: ConnectivityHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.connectivityHandler = (UIApplication.shared.delegate as? AppDelegate)?.connectivityHandler
        self.connectivityHandler.addObserver(self, forKeyPath: "myMessage", options: [], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "myMessage"{
            DispatchQueue.main.async(execute: {
                let message = self.connectivityHandler.myMessage
                let circlePageController = circlePage()
                circlePageController.message = message
                self.navigationController?.pushViewController(circlePageController, animated: true)
            })
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let data = buses[indexPath.row]
        cell.textLabel?.text = data
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlData = urlArr[indexPath.row]
        let statiiPageNav = statiiPage()
        statiiPageNav.coreURL = urlData
        self.navigationController?.pushViewController(statiiPageNav, animated: true )
    }
    

}


//
//  statiiPage.swift
//  ratbvApp
//
//  Created by Andrew on 1/4/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit

struct myStruct: Decodable{
    let statii: [String]?
}


class statiiPage: UITableViewController{
    
    var statiiNamesArr = [String]()
    let cellId = "cellId"
    var coreURL: String! = nil{
        didSet{
            let url = URL(string: coreURL)
            
            let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, err) in
                if err != nil{
                    print(err?.localizedDescription)
                    return
                }
                guard let data = data else { return }
                do{
                    let dictData = try JSONDecoder().decode(myStruct.self, from: data)
                    guard let statii = dictData.statii else { return } /// trebuie sa fie key ul statii nu statiiNames
                    for statieName in statii{
                        self.statiiNamesArr.append(statieName)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch let err{
                    print(err.localizedDescription)
                }
            }
            dataTask.resume()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statiiNamesArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let statiiData = statiiNamesArr[indexPath.row]
        cell.textLabel?.text = statiiData
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let statiiData = statiiNamesArr[indexPath.row]
        let orarStatiePage = orarStatie()
        orarStatiePage.coreURL = coreURL
        orarStatiePage.statieName = statiiData
        self.navigationController?.pushViewController(orarStatiePage, animated: true)
    }
    
}














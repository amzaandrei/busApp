//
//  orarStatie.swift
//  ratbvApp WatchKit Extension
//
//  Created by Andrew on 1/4/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit


class orarStatie: UITableViewController{
    
    var coreURL: String! = nil
    var minutes = [Int]()
    var orarArrVar: [Int: [Int]] = [:]
    let cellId = "cellId"
    var statieName: String! = nil{
        didSet{
            let url = URL(string: coreURL)
            
            let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, err) in
                if err != nil{
                    print(err?.localizedDescription)
                    return
                }
                guard let data = data else { return }
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any] else { return }
                    guard let orarStatieJson = json[self.statieName] as? [String: [Int]] else { return }
                    for elemIndex in (5...23){
                        guard let allHours = orarStatieJson[String(elemIndex)] else { return }
                        for elem in allHours{
                            self.minutes.append(elem)
                        }
                        self.orarArrVar[elemIndex] = self.minutes
                        self.minutes.removeAll()
                    }
                    DispatchQueue.main.sync(execute: {
                        if self.orarArrVar.count != 0{
                            self.orarArrVar.sorted(by: { (key1,key2) -> Bool in
                                return key1.key < key2.key
                            })
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.register(customCell.self, forCellReuseIdentifier: self.cellId)
                            self.tableView.reloadData()
                        }
                    })
                }catch let err{
                    print(err.localizedDescription)
                }
            }
            dataTask.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        print(orarArrVar.count)
//        return orarArrVar.count
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orarArrVar.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! customCell
        let data = Array(self.orarArrVar.keys)[indexPath.row]
        cell.textLabel?.text = String(describing: data)
        var finalStr = ""
        for val in Array(self.orarArrVar.values)[indexPath.row]{
            finalStr = finalStr + String(val) + " "
        }
        cell.label.text = finalStr
        return cell
    }
    
}


class customCell: UITableViewCell{
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "asd"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cellId")
        addSubview(label)
        addConstraints()
    }
    
    func addConstraints(){
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

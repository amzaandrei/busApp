//
//  InterfaceController.swift
//  ratbvApp WatchKit Extension
//
//  Created by Andrew on 1/4/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import WatchKit
import Foundation

struct myStruct: Decodable{
    let statii: [String]?
}

class statiiPage: WKInterfaceController {
    
    var statiiNames = [String]()
    @IBOutlet var myTable: WKInterfaceTable!
    var globalLink: String! = nil
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let link = context as? String{
            globalLink = link
            getJsonFile(link: link)
        }
    }
    
    func getJsonFile(link: String){
        let url = URL(string: link)
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if err != nil{
                print(err?.localizedDescription)
                return
            }
            guard let data = data else { return }
            do{
                let allData = try JSONDecoder().decode(myStruct.self,from: data)
                guard let statii = allData.statii else { return }
                for statie in statii{
                    self.statiiNames.append(statie)
                }
                self.addDataToTable()
            }catch let err{
                print(err.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    func addDataToTable(){
        
        myTable.setNumberOfRows(statiiNames.count, withRowType: "myCustomTableCell")
        for (index,statieName) in statiiNames.enumerated(){
            let row = myTable.rowController(at: index) as! myCustomTableCell
            row.myCellLabel.setText(statieName)
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let data = statiiNames[rowIndex]
        let values = ["data":data,"globalLink": globalLink]
        self.pushController(withName: "orarStatie", context: values)
//        WKInterfaceController.reloadRootControllers(withNamesAndContexts: [(name: "statiiPage", context: self)])
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

class myCustomTableCell: NSObject{
    @IBOutlet var myCellLabel: WKInterfaceLabel!
}





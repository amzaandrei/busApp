//
//  bussesViewController.swift
//  busssssApp WatchKit Extension
//
//  Created by Andrew on 1/15/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit
import WatchKit

class bussesViewController: WKInterfaceController{
    
    
    @IBOutlet var myTable: WKInterfaceTable!
    let bussesNameArr = ["36","8"]
    let linkBussesRef = ["https://api.myjson.com/bins/m0b4j","https://api.myjson.com/bins/19bsql"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.addTable()
    }
    
    func addTable(){
        myTable.setNumberOfRows(bussesNameArr.count, withRowType: "myCustomBusCell")
        for (index,busName) in bussesNameArr.enumerated(){
            let row = myTable.rowController(at: index) as! myCustomBusCell
            row.busLabel.setText(busName)
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let linkRef = linkBussesRef[rowIndex]
        self.pushController(withName: "statiiPage", context: linkRef)
    }
    
}

class myCustomBusCell: NSObject{
    @IBOutlet var busLabel: WKInterfaceLabel!   
}

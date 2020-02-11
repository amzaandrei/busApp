//
//  File.swift
//  ratbvApp
//
//  Created by Andrew on 1/4/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit
import WatchKit

class StationsSchedule: WKInterfaceController{
    
    @IBOutlet var myTable: WKInterfaceTable!
    var coreURL: String! = nil
    var minutes = [Int]()
    var orarArrVar: [Int: [Int]] = [:]
    let cellId = "cellId"
    var connectionHandler: ConnectionHandlerAppleWatch!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.connectionHandler = ConnectionHandlerAppleWatch()
        if let dict = context as? [String: Any] {
            let loc = dict["data"] as! String
            let url = dict["globalLink"] as! String
            self.fetchData(loc: loc,url: url)
            } else {
                print("An error occurred")
            }
    }
    
    
    
    func fetchData(loc: String,url: String){
        let urll = URL(string: url)
        let dataTask = URLSession.shared.dataTask(with: urll!) { (data, response, err) in
            if err != nil{
                print(err?.localizedDescription)
                return
            }
            guard let data = data else { return }
            do{
                guard let json = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any] else { return }
                print(json)
                guard let orarStatieJson = json[loc] as? [String: [Int]] else { return }
                print(orarStatieJson)
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
                        self.addToTable()
                    }
                })
            }catch let err{
                print(err.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    
    
    func addToTable(){
        myTable.setNumberOfRows(orarArrVar.count, withRowType: "orarCustomTableCell")
        for (index,ora) in Array(self.orarArrVar.keys).enumerated(){
            let row = myTable.rowController(at: index) as! orarCustomTableCell
            row.oraLabel.setText(String(ora) + ":")
            var finalStr = ""
            for val in Array(self.orarArrVar.values)[index]{
                finalStr = finalStr + String(val) + " "
            }
            row.minuteLabel.setText(finalStr)
            
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let hour = Array(orarArrVar.keys)[rowIndex]
        let minutes = Array(orarArrVar.values)[rowIndex]
        getCurrentHour(hour: hour,minutes: minutes,rowIndex: rowIndex)
    }
    
    func getCurrentHour(hour: Int,minutes: [Int],rowIndex: Int){
        let date = Date()
        let calendar = Calendar.current
        
        let currentHour = calendar.component(.hour, from: date)
        if currentHour != hour{
            let action = WKAlertAction(title: "Ok", style: .default, handler: {})
            self.presentAlert(withTitle: "Important", message: "The selected hour must be eqaul with your current time", preferredStyle: .alert, actions: [action])
            return
        }
        let currentMinute = calendar.component(.minute, from: date)
        getTheNearestMinute(currentMinute: currentMinute,minutes: minutes,currentHour: currentHour,rowIndex: rowIndex)
    }
    
    func getTheNearestMinute(currentMinute: Int,minutes: [Int],currentHour: Int,rowIndex: Int){
        var smallestDif = currentMinute - minutes[0]
        var closest = 0
        
        for (index,minute) in minutes.enumerated(){
            let currentDif = currentMinute - minute
            if currentDif < smallestDif && currentMinute < minute{
                smallestDif = currentDif
                closest = index
                break
            }
        }
        var difference = minutes[closest] - currentMinute
        if difference < 0{
            var finalMin = 0
            for elem in Array(orarArrVar.values)[rowIndex + 1]{
                finalMin = elem
                break
            }
            let min = (currentHour + 1) * 60 - currentHour * 60
            difference = min + finalMin
        }
        let values = ["currentHour": currentHour,"currentMinute": currentMinute,"difference": difference]
        self.pushController(withName: "CircularTimer", context: values)
        self.iphoneData(time: difference)
    }
    
    func iphoneData(time: Int){
        let value = ["time": time]
        connectionHandler.session.sendMessage(value, replyHandler: nil) { (err) in
            print(err.localizedDescription)
        }
    }
    
    
    
    override func willActivate() {
        
        super.willActivate()
    }
    
    override func didDeactivate() {
        
        super.didDeactivate()
    }
    
}



class orarCustomTableCell: NSObject{
    @IBOutlet var oraLabel: WKInterfaceLabel!
    @IBOutlet var minuteLabel: WKInterfaceLabel!
}

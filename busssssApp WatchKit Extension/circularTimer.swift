//
//  circularTimer.swift
//  ratbvApp WatchKit Extension
//
//  Created by Andrew on 1/5/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit
import WatchKit

class circularTimer: WKInterfaceController{
    
    var timer: Timer!
    var seconds: Int = 0
    var connectionHandler: ConnectionHandlerAppleWatch!
    var currentHour: Int = 0
    var currentMinute: Int = 0
    var circleStarting: Int = 0
    var currentDetSec: Int = 0
    var currentDetMin: Int = 0
    
    @IBOutlet var imageObject: WKInterfaceImage!
    @IBOutlet var timerLabel: WKInterfaceLabel!
    
    @IBAction func viewTappped(_ sender: Any) {
        if let _ = sender as? WKTapGestureRecognizer{
            let action = WKAlertAction(title: "Wow", style: .default, handler: {})
            self.presentAlert(withTitle: "Yey", message: "You did it! :)", preferredStyle: .alert, actions: [action])
            timer.invalidate()
            self.pop()
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.connectionHandler = ConnectionHandlerAppleWatch()
        if let dict = context as? [String: Int]{
            currentHour = dict["currentHour"]!
            currentMinute = dict["currentMinute"]!
            seconds = 60 * dict["difference"]!
            animateImagesWithTime(circleStarting: 0)
            updateLabel()
        }
//        if let val = context as? Int{
//            seconds = 60 * val
//            animateImagesWithTime()
//            updateLabel()
//        }
        self.connectionHandler.addObserver(self, forKeyPath: "findOut", options: [], context: nil)
    }
    func animateImagesWithTime(circleStarting: Int){
        imageObject.setImageNamed("inner")
        imageObject.startAnimatingWithImages(in: NSMakeRange(circleStarting, 100), duration: TimeInterval(seconds), repeatCount: 1)
    }
    
    func updateLabel(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownTick), userInfo: nil, repeats: true)
    }
    
    @objc func countDownTick(){
        let timerStr = stringFromTimeInterval()
        if seconds == 0{
            WKInterfaceDevice.current().play(.notification)
            timer.invalidate()
            self.timerLabel.setText(timerStr)
            let action = WKAlertAction(title: "OK", style: .default, handler: {})
            self.presentAlert(withTitle: "Sadly", message: "Unfortunately you didn't make it :/", preferredStyle: .alert, actions: [action])
            return
        }else if seconds == 60 || seconds == 120{
            WKInterfaceDevice.current().play(.notification)
        }
        self.seconds = self.seconds - 1
        self.timerLabel.setText(timerStr)
        circleStarting = circleStarting + 1
    }
    func stringFromTimeInterval() -> String{
        let minutes = self.seconds / 60 % 60
        let seconds = self.seconds % 60
        return String(format: "%0.2d:%0.2d", arguments: [minutes,seconds])
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "findOut"{
            DispatchQueue.main.sync {
                let className = ConnectionHandlerAppleWatch()
                let value = className.findOut
                var messageToDisplay: String! = nil
                if value{
                    messageToDisplay = "Yey your really did it!"
                }else{
                    messageToDisplay = "Noooo. I can't believe it. Next time dude!"
                }
                let action = WKAlertAction(title: "Ok", style: .default, handler: {
                    self.timer.invalidate()
                    self.pop()
                })
                self.presentAlert(withTitle: "Important", message: messageToDisplay, preferredStyle: .alert, actions: [action])
            }
        }
    }
    
    
    override func willActivate() {
//        let date = Date()
//        let calendar = Calendar.current
//
//        let currentActSec = calendar.component(.second, from: date)
//        let currentActMin = calendar.component(.minute, from: date)
//        seconds = (currentMinute - currentDetMin) * 60 + currentActSec - currentDetSec
//        print(seconds)
//        circleStarting = circleStarting + seconds
//        animateImagesWithTime(circleStarting: circleStarting)
//        updateLabel()
//        print("circleStarting act: " + String(currentActHour))
//        print("circleStarting act: " + String(currentActMin))
        super.willActivate()
    }
    
    override func didDeactivate() {
//        let date = Date()
//        let calendar = Calendar.current
//
//        currentDetSec = calendar.component(.second, from: date)
//        currentDetMin = calendar.component(.minute, from: date)
//        print("circleStarting dect: " + String(currentDetHour))
//        print("circleStarting dect: " + String(currentDetMin))
        super.didDeactivate()
    }
    
}

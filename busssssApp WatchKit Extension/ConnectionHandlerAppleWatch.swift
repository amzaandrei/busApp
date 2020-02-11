//
//  ConnectionHandlerAppleWatch.swift
//  busssssApp WatchKit Extension
//
//  Created by Andrew on 1/16/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit
import WatchConnectivity

class ConnectionHandlerAppleWatch: NSObject, WCSessionDelegate{
    
    var session = WCSession.default
    @objc dynamic var findOut: Bool = false
    override init() {
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let finalValueArrival = message["arrival"] as? Bool{
            findOut = finalValueArrival
        }
    }
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
    }
    
}

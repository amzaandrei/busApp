//
//  ConnectivityHandler.swift
//  busssssApp
//
//  Created by Andrew on 1/16/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import Foundation
import WatchConnectivity

class ConnectivityHandler: NSObject , WCSessionDelegate{
    
    var session = WCSession.default
    
    @objc dynamic var myMessage: Int = 0
    
    override init() {
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        myMessage = message["time"] as! Int
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(error)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("%@", "sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("%@", "sessionDidDeactivate: \(session)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        NSLog("%@", "sessionWatchStateDidChange: \(session)")
    }
    
}

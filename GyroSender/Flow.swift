//
//  Flow.swift
//  GyroSender
//
//  Created by Damiaan Dufaux on 8/06/16.
//  Copyright © 2016 Damiaan Dufaux. All rights reserved.
//

import Foundation
import SwiftDDP

let flow = Flow()

class Flow: NSObject {
    let browser = NSNetServiceBrowser()
    var moduleId: String?
    
    var searchController: SearchController?
    var viewController: ViewController?
    var visualisationService: NSNetService?
    let visualisationServiceURL = "wss://visualisation.eu.meteorapp.com/websocket"

    override init() {
        super.init()
    }
    
    func connectToServer() {        
        Meteor.client.logLevel = .Warning
        Meteor.connect(visualisationServiceURL, callback: registerModule)
    }

    func registerOnline() {
        let event: [String: AnyObject] = [
            "type": "state",
            "payload": 2,
            "senderId": moduleId!
        ]
        Meteor.call("registerWebsocketEvent", params: [event], callback: nil)
    }
    
    func registerModule() {
        if moduleId == nil {
            Meteor.call("registerWebsocketModule", params: [["type": "iPhone", "name": UIDevice.currentDevice().name]]) { (result, error) in
                if let moduleId = result as? String {
                    self.moduleId = moduleId
                    self.registerOnline()
                }
            }
        } else {
            registerOnline()
        }
    }
    
    func unregisterModule() {
        if let moduleId = moduleId {
            let event: [String: AnyObject] = [
                "type": "state",
                "payload": 0,
                "senderId": moduleId
            ]
            Meteor.call("registerWebsocketEvent", params: [event], callback: nil)
        }
    }
}
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

class Module: MeteorDocument {
    var name: String?
    var type: String?
    var parent: String?
    
    required init(id: String, fields: NSDictionary?) {
        super.init(id: id, fields: fields)
    }
    
    convenience init(name: String, type: String) {
        self.init(id: Meteor.client.getId(), fields: ["name": name, "type": type])
    }
}

class Flow: NSObject {
    let browser = NSNetServiceBrowser()
    var module: Module?
    
    var searchController: SearchController?
    var viewController: ViewController?
    var visualisationService: NSNetService?
    var visualisationServiceURL: String?
    let modules = MeteorCollection<Module>(name: "modules")

    override init() {
        super.init()
        browser.delegate = self
        
        browser.searchForServicesOfType("_websocket._tcp", inDomain: "")
    }
    
    func connectToServer() {
        searchController?.gotoNextScreen()
        
        Meteor.client.logLevel = .Warning
        Meteor.connect(visualisationServiceURL!, callback: registerModule)
    }

    
    func registerModule() {
        if module == nil {
            module = Module(name: UIDevice.currentDevice().name, type: "iPhone")
            modules.insert(module!)
        }
    }
    
    func unregisterModule() {
        if let module = module {
            modules.remove(module)
            self.module = nil
        }
    }
}

extension Flow: NSNetServiceBrowserDelegate, NSNetServiceDelegate {
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {
        service.delegate = self
        service.resolveWithTimeout(60)
        print("resolve service")
        visualisationService = service
    }
    
    func netServiceBrowserWillSearch(browser: NSNetServiceBrowser) {
        print("netServiceBrowser will search")
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("netServiceBrowser did not search")
    }
    
    func netServiceDidResolveAddress(sender: NSNetService) {
        print("resolved address")
        if let txt = sender.TXTRecordData() {
            visualisationServiceURL = NSString(bytes: txt.bytes.advancedBy(5), length: txt.length-5, encoding: NSUTF8StringEncoding) as? String
            connectToServer()
        } else {
            print("no txt record")
        }
    }
    
    func netService(sender: NSNetService, didNotResolve errorDict: [String : NSNumber]) {
        print("service did not resolve")
        print(errorDict)
    }
    
    func netServiceDidStop(sender: NSNetService) {
        if sender == visualisationService {
            visualisationService = nil
            viewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
//
//  ViewController.swift
//  GyroSender
//
//  Created by Damiaan Dufaux on 8/06/16.
//  Copyright © 2016 Damiaan Dufaux. All rights reserved.
//

import UIKit
import SwiftDDP
import CoreMotion

let motionManager = CMMotionManager()

func round2(number: Double) -> Double {
    let factor = 100.0
    return round(number*factor)
}

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var serverLabel: UILabel!

    @IBOutlet weak var rollBar: UIProgressView!
    @IBOutlet weak var pitchBar: UIProgressView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if motionManager.gyroAvailable {
            motionManager.deviceMotionUpdateInterval = 0.15
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (data, error) in
                if let attitude = data?.attitude {
                    self.rollBar.setProgress(Float((attitude.roll / M_PI / 2) + 0.5), animated: false)
                    self.pitchBar.setProgress(Float((attitude.pitch / M_PI / 2) + 0.5), animated: false)
                    self.progressBar.setProgress(Float((attitude.yaw / M_PI / 2) + 0.5), animated: false)
                    let r = attitude.rotationMatrix
                    if let moduleId = flow.moduleId {
                        Meteor.call("registerWebsocketEvent", params: [[
                            "senderId": moduleId,
                            "type": "gyro",
                            "payload": [
                                atan2(r.m32, r.m33)+M_PI_2,
                                -atan2(-r.m31, sqrt(pow(r.m32, 2)+pow(r.m33, 2))),
                                atan2(r.m21, r.m11)
                            ]
                        ]], callback: nil)
                    }
                }
            }
        } else {
            print("gyro not available")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        serverLabel.text = flow.visualisationService?.hostName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveName(sender: AnyObject) {
        if let newName = nameTextField.text {
            let event: [String: AnyObject] = [
                "type": "name",
                "payload": newName,
                "senderId": flow.moduleId!
            ]
            Meteor.call("registerWebsocketEvent", params: [event], callback: nil)
        }
    }
}
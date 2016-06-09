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

    override func viewDidLoad() {
        super.viewDidLoad()
        if motionManager.gyroAvailable {
            print("timeInterval: \(motionManager.gyroUpdateInterval)")
            motionManager.deviceMotionUpdateInterval = 0.1
            print(motionManager.gyroUpdateInterval)
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (data, error) in
                if let attitude = data?.attitude {
                    let rounded = (round2(attitude.roll), round2(attitude.pitch), round2(attitude.yaw))
                    self.label.text = "\(rounded.0) \(rounded.1) \(rounded.2)"
                }
            }
        } else {
            print("gyro not available")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveName(sender: AnyObject) {
        if let newName = nameTextField.text {
            let event: [String: AnyObject] = [
                "type": "nameChange",
                "payload": newName,
                "senderId": flow.moduleId!
            ]
            Meteor.call("registerWebsocketEvent", params: [event], callback: nil)
        }
    }
}
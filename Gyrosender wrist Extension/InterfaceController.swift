//
//  InterfaceController.swift
//  Gyrosender wrist Extension
//
//  Created by Damiaan Dufaux on 9/06/16.
//  Copyright © 2016 Damiaan Dufaux. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

let motionManager = CMMotionManager()
func round2(number: Double) -> Double {
    let factor = 100.0
    return round(number*factor)
}


class InterfaceController: WKInterfaceController {

    @IBOutlet var xSlider: WKInterfaceSlider!
    @IBOutlet var ySlider: WKInterfaceSlider!
    @IBOutlet var zSlider: WKInterfaceSlider!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        
        if motionManager.accelerometerAvailable {
            print("timeInterval: \(motionManager.gyroUpdateInterval)")
            motionManager.accelerometerUpdateInterval = 0.1
            print(motionManager.accelerometerUpdateInterval)
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (data, error) in
                if let acceleration = data?.acceleration {
                    self.xSlider.setValue(Float(acceleration.x * 100))
                    self.ySlider.setValue(Float(acceleration.y * 100))
                    self.zSlider.setValue(Float(acceleration.z * 100))
                }
            }
        } else {
//            label.setText("Accelerometer not available")
        }
        // Configure interface objects here.
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

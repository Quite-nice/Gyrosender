//
//  SearchController.swift
//  GyroSender
//
//  Created by Damiaan Dufaux on 8/06/16.
//  Copyright © 2016 Damiaan Dufaux. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    func gotoNextScreen() {
        performSegueWithIdentifier("goToSender", sender: self)
    }
    
    override func viewDidLoad() {
        flow.searchController = self
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func click(sender: AnyObject) {
        
    }
}
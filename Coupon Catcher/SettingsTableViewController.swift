//
//  SettingsTableViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 31/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    let defaultData = NSUserDefaults.standardUserDefaults()
    @IBOutlet var testingModeButton: UISwitch!
    
    override func viewDidAppear(animated: Bool) {
        testingModeButton.on = defaultData.boolForKey("testingMode")
    }
    
    @IBAction func testingModeButtonValueChanged(sender: UISwitch) {
        defaultData.setBool(sender.on, forKey: "testingMode")
        NSNotificationCenter.defaultCenter().postNotificationName("TestingModeChanged", object: nil)
    }

}

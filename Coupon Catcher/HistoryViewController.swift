//
//  HistoryViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 24/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit
import MapKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
    }

}

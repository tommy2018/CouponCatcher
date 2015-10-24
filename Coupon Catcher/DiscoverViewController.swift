//
//  DiscoverViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 24/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    var backgroundImageNames: [String]?;
    var backgroundIndex = 0;
    @IBOutlet var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageNames = ["phillips_island", "hot_balloons", "quicksilver", "taiwan", "sydney", "great_barrier_reef", "on_hot_balloon", "sunrise", "perisher", "phillips_island_meadow"];
        
        changeBackground()
    }
    
    func changeBackground() {
        if backgroundIndex >= backgroundImageNames!.count {
            backgroundIndex = 0;
        }
        
        backgroundImageView.image = UIImage(named: backgroundImageNames![backgroundIndex])
        backgroundIndex++;
    }
}

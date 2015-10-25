//
//  NearByViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 24/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit

class NearByViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let beaconCatcher = BeaconCatcher.sharedInstance
    @IBOutlet var noLocationServiceView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    let imageNames = ["phillips_island", "sydney", "quicksilver", "hot_balloons", "perisher"]
    let shopNames = ["Phillips Island", "Sydney Nightlife", "Cairns Holiday", "Hot Balloon Adventure", "Snow Sport Outlet"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startForegroundMonitoring", name: "LocationServiceEnabled", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "disableLocationService", name: "LocationServiceDisabled", object: nil)
        collectionView.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func startForegroundMonitoring() {
        noLocationServiceView.hidden = true
        beaconCatcher.startForegroundMonitoring()
        print("Start foreground monitoring")
    }
    
    func disableLocationService() {
        noLocationServiceView.hidden = false
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("shopCell", forIndexPath: indexPath)
        
        (cell as! ShopCell).shopNameLabel.text = shopNames[indexPath.row]
        (cell as! ShopCell).shopImageView.image = UIImage(named: imageNames[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.width / 3 * 2)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = self.collectionView!.indexPathForCell(cell)
        
        (segue.destinationViewController as! CouponsTableViewController).shopName = shopNames[indexPath!.row]
    }
}
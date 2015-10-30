//
//  NearByViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 24/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit
import CoreLocation

struct ShopData {
    var shopName: String
    var shopStreet: String
    var shopTown: String
    var shopLat: String
    var shopLng: String
    var shopPhone: String
    var beaconID: String
    var image: String
}

class NearByViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let beaconCatcher = BeaconCatcher.sharedInstance
    @IBOutlet var noLocationServiceView: UIView!
    @IBOutlet var noLocationServiceLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    let apiURL = "http://10.64.169.231/index.php"
    let imageURL = "http://10.64.169.231/images/"
    var shopsByBeaconID = [Int: [ShopData]]()
    var lastRequestTime = NSDate()
    var lastUpdateTime = NSDate()
    var shopArray = [ShopData]()
    let defaultData = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Listen to these notifications
        
        testingModeChanged()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "testingModeChanged", name: "TestingModeChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startForegroundMonitoring", name: "LocationServiceEnabled", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "disableLocationService", name: "LocationServiceDisabled", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beaconUpdateHandler", name: "BeaconsUpdated", object: nil)
        
        collectionView.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func testingModeChanged() {
        if defaultData.boolForKey("testingMode") {
            print("Testing mode")
            beaconUpdateHandler()
        }
    }
    
    func startForegroundMonitoring() {
        //Start monitoring beeacons
        noLocationServiceView.hidden = true
        beaconCatcher.startForegroundMonitoring()
        print("Start foreground monitoring")
    }
    
    func disableLocationService() {
        //Prompt user that loccation service is not available for this app
        noLocationServiceLabel.text = "Location service not enabled for this application"
        noLocationServiceView.hidden = false
    }
    
    func beaconUpdateHandler() {
        /*
            First step:     Get beacons' id every 10 seconds (Beacon's Minor)
            Second step:    Send found beacons' id back to server
            Third step:     Parse JSON
            Fourth step:    reload collection view
        */
        
        if lastRequestTime.compare(NSDate().dateByAddingTimeInterval(NSTimeInterval(-5))) == NSComparisonResult.OrderedAscending {
            self.lastRequestTime = NSDate()
            
            if defaultData.boolForKey("testingMode") {
                performNetworkRequest("512,513")
                return
            }
            
            let beacons = beaconCatcher.beacons
        
            if beacons != nil {
                if beacons!.count > 0 {
                    var beaconIDs = ""
                    var found = false
                
                    for beacon in beacons! {
                        if beacon.rssi != 0 {
                            beaconIDs += "\(beacon.minor),"
                            found = true
                        }
                    }
                    
                    if found {
                        beaconIDs.removeAtIndex(beaconIDs.endIndex.predecessor())
                        print(beaconIDs)
                        performNetworkRequest(beaconIDs)
                    }
                } else {
                    //No more beacons, delete all entries
                    shopsByBeaconID.removeAll()
                    self.reloadData()
                }
            }
        }
    }
    
    func performNetworkRequest(beaconIDs: String) {
        let components = NSURLComponents(string: apiURL)
        let beaconIDsQI = NSURLQueryItem(name: "beaconids", value: beaconIDs)
        let urlSession = NSURLSession.sharedSession()
        
        components?.queryItems = [beaconIDsQI]
        
        if components?.URL != nil {
            print(components?.URL)
            let task = urlSession.dataTaskWithURL(components!.URL!, completionHandler: {(data, response, error) in
                do {
                    if data != nil {
                        let response = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSArray
                        //print(String(data: data!, encoding: NSUTF8StringEncoding))
                        
                        if response != nil {
                            self.shopsByBeaconID = [Int: [ShopData]]()
                            for entry in response! {
                                if let data = entry as? NSDictionary {
                                    let shop = ShopData(shopName: data["shopName"] as! String, shopStreet: data["shopStreet"] as! String,
                                        shopTown: data["shopTown"] as! String, shopLat: data["shopLat"] as! String,
                                        shopLng: data["shopLng"] as! String, shopPhone: data["phone"] as! String, beaconID: data["minor"] as! String, image: data["bg"] as! String)
                                    
                                    
                                    if let minor = Int(shop.beaconID) {
                                        print(minor)
                                        if self.shopsByBeaconID[minor] == nil {
                                            self.shopsByBeaconID[minor] = [ShopData]()
                                        }
                                        
                                        self.shopsByBeaconID[minor]!.append(shop)
                                    }
                                }
                            }
                            
                            print("PARSED")
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.reloadData()
                            })
                            
                        } else {
                            /* unable to parse data to a nsdictionary object */
                            print("PARSE ERROR: NSDICTIONARY")
                        }
                    } else {
                        /* no data returned */
                        print(components!.URL)
                        print("NO DATA RETURNED")
                    }
                } catch {
                    /* unable to parse json data */
                    print("PARSE ERROR")
                }
            })
            
            task.resume()
        } else {
            /* unable to create an url */
            print("URL ERROR")
        }
    }
    
    func removeUndetectedShops(beacons: [CLBeacon]) {
        for beacon in beacons {
            if shopsByBeaconID[Int(beacon.minor)] != nil {
                shopsByBeaconID[Int(beacon.minor)] = [ShopData]()
            }
        }
    }
    
    func reloadData() {
        shopArray.removeAll()
        
        for shops in shopsByBeaconID {
            for shop in shops.1 {
                self.shopArray.append(shop)
            }
        }
        
        if shopArray.count > 0 {
            noLocationServiceView.hidden = true
            self.collectionView.reloadData()
        } else {
            noLocationServiceLabel.text = "No nearby shops found"
            noLocationServiceView.hidden = false
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("shopCell", forIndexPath: indexPath)
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        
        dispatch_async(backgroundQueue, {
            if let url = NSURL(string: "\(self.imageURL)\(self.shopArray[indexPath.row].image)") {
                let imageData = NSData(contentsOfURL: url)
            
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                
                    dispatch_async(dispatch_get_main_queue(), {
                        (cell as! ShopCell).shopImageView.image = image
                    })
                }
            }
        })
        
        (cell as! ShopCell).shopNameLabel.text = shopArray[indexPath.row].shopName

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.width / 3 * 2)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = self.collectionView!.indexPathForCell(cell)
        
        (segue.destinationViewController as! CouponsTableViewController).shop = shopArray[indexPath!.row]
    }
}
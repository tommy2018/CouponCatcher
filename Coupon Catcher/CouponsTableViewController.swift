//
//  CouponsTableViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 26/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit

struct CouponData {
    var shopName: String
    var shopStreet: String
    var shopTown: String
    var validFrom: String
    var validTo: String
    var couponDesc: String
    var couponFinePrint: String
    var background: String
    var phone: String
    var category: String
    var code: String
    var shopLat: String
    var shopLng: String
    var bg: String
}

class CouponsTableViewController: UITableViewController {
    var shop: ShopData?
    var coupons = [CouponData]()
    let apiURL = "http://10.64.169.231/index.php"
    let imageURL = "http://10.64.169.231/images/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performNetworkRequest(shop!.shopName)
    }
    
    func performNetworkRequest(shopName: String) {
        let components = NSURLComponents(string: apiURL)
        let beaconIDsQI = NSURLQueryItem(name: "shopName", value: shopName)
        let actionQI = NSURLQueryItem(name: "do", value: "get-coupons")
        let urlSession = NSURLSession.sharedSession()
        
        components?.queryItems = [actionQI, beaconIDsQI]
        
        if components?.URL != nil {
            let task = urlSession.dataTaskWithURL(components!.URL!, completionHandler: {(data, response, error) in
                do {
                    if data != nil {
                        let response = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSArray
                        
                        if response != nil {
                            
                            for entry in response! {
                                if let data = entry as? NSDictionary {
                                    let coupon = CouponData(shopName: self.shop!.shopName, shopStreet: self.shop!.shopStreet, shopTown: self.shop!.shopTown, validFrom: data["validFrom"] as! String, validTo: data["validTo"] as! String, couponDesc: data["desc"] as! String, couponFinePrint: data["finePrint"] as! String, background: "", phone: self.shop!.shopPhone, category: data["category"] as! String, code: data["code"] as! String, shopLat: self.shop!.shopLat, shopLng: self.shop!.shopLng, bg: data["bg"] as! String)
                                    
                                    self.coupons.append(coupon)
                                }
                                
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.tableView.reloadData()
                            })
                            
                        } else {
                            /* unable to parse data to a nsdictionary object */
                            print("PARSE ERROR: NSARRAY")
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shopCouponCell", forIndexPath: indexPath)
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        
        dispatch_async(backgroundQueue, {
            if let url = NSURL(string: "\(self.imageURL)\(self.coupons[indexPath.row].bg)") {
                let imageData = NSData(contentsOfURL: url)
                
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        (cell as! ShopCouponTableViewCell).couponImageView.image = image
                    })
                }
            }
        })

        (cell as! ShopCouponTableViewCell).descriptionLabel.text = coupons[indexPath.row].couponDesc
        (cell as! ShopCouponTableViewCell).categoryLabel.text = "🏷 \(coupons[indexPath.row].category)"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = (segue.destinationViewController as! UINavigationController).visibleViewController as! CouponDetailsViewController
        controller.couponData = coupons[self.tableView.indexPathForSelectedRow!.row]
    }
}

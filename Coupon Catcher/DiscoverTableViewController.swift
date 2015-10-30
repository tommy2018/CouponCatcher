//
//  DiscoverTableViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 26/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit

class DiscoverTableViewController: UITableViewController {
    let apiURL = "http://10.64.169.231/index.php"
    let imageURL = "http://10.64.169.231/images/"
    var coupons = [CouponData]()
    @IBOutlet var reloadButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadButton.enabled = false
        performNetworkRequest()
    }
    
    @IBAction func reloadButtonPressed(sender: AnyObject) {
        reloadButton.enabled = false
        performNetworkRequest()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discoverCell", forIndexPath: indexPath)
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        
        dispatch_async(backgroundQueue, {
            if let url = NSURL(string: "\(self.imageURL)\(self.coupons[indexPath.row].bg)") {
                let imageData = NSData(contentsOfURL: url)
                
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        (cell as! DiscoverListCell).couponImageView.image = image
                    })
                }
            }
        })
        
        (cell as! DiscoverListCell).shopNameLabel.text = "🏪 \(coupons[indexPath.row].shopName)"
        (cell as! DiscoverListCell).coupounDescLabel.text = "\(coupons[indexPath.row].couponDesc)"
        (cell as! DiscoverListCell).categoryLabel.text = "🏷 \(coupons[indexPath.row].couponDesc)"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let sb = (segue.destinationViewController as! UINavigationController).visibleViewController as! CouponDetailsViewController
        sb.couponData = coupons[self.tableView.indexPathForSelectedRow!.row]
    }
    
    func performNetworkRequest() {
        let components = NSURLComponents(string: apiURL)
        let actionQI = NSURLQueryItem(name: "do", value: "all")
        let urlSession = NSURLSession.sharedSession()
        
        components?.queryItems = [actionQI]
        
        if components?.URL != nil {
            let task = urlSession.dataTaskWithURL(components!.URL!, completionHandler: {(data, response, error) in
                do {
                    if data != nil {
                        let response = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSArray
                        
                        if response != nil {
                            self.coupons.removeAll()
                            for entry in response! {
                                if let data = entry as? NSDictionary {
                                    let coupon = CouponData(shopName: data["shopName"] as! String, shopStreet: data["shopStreet"] as! String, shopTown: data["shopTown"] as! String, validFrom: data["validFrom"] as! String, validTo: data["validTo"] as! String, couponDesc: data["desc"] as! String, couponFinePrint: data["finePrint"] as! String, background: "", phone: data["phone"] as! String, category: data["category"] as! String, code: data["code"] as! String, shopLat: data["shopLat"] as! String, shopLng: data["shopLng"] as! String, bg: data["bg"] as! String)
                                    
                                    self.coupons.append(coupon)
                                }
                                
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.tableView.reloadData()
                                self.reloadButton.enabled = true
                            })
                            
                        } else {
                            /* unable to parse data to a nsdictionary object */
                            print("PARSE ERROR: NSARRAY")
                            self.reloadButton.enabled = true
                        }
                    } else {
                        /* no data returned */
                        print(components!.URL)
                        print("NO DATA RETURNED")
                        self.reloadButton.enabled = true
                    }
                } catch {
                    /* unable to parse json data */
                    print("PARSE ERROR")
                    self.reloadButton.enabled = true
                }
            })
            
            task.resume()
        } else {
            /* unable to create an url */
            print("URL ERROR")
            self.reloadButton.enabled = true
        }
        
    }
}

//
//  CouponsTableViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 26/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

struct ShopCoupon {
    var backgroundUrl: String
    var description: String
}

import UIKit

class CouponsTableViewController: UITableViewController {
    var shopName: String?
    let items = [ShopCoupon(backgroundUrl: "on_hot_balloon", description: "1.5 hour hot balloon tour with complimentary hot breakfast fot just $162. Offer ends 21st October!"),
        ShopCoupon(backgroundUrl: "taiwan", description: "Experience a real farm and interact with animals at Phillips Island. 1 day tour with lunch provided just for $87.99!")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shopName! == "Phillips Island" || shopName! == "Hot Balloon Adventure" {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shopCouponCell", forIndexPath: indexPath)

        if shopName! == "Phillips Island" {
            (cell as! ShopCouponTableViewCell).couponImageView.image = UIImage(named: items[1].backgroundUrl)
            (cell as! ShopCouponTableViewCell).descriptionLabel.text = items[1].description
            (cell as! ShopCouponTableViewCell).categoryLabel.text = "🏷 Travel"
        } else if shopName! == "Hot Balloon Adventure" {
            (cell as! ShopCouponTableViewCell).couponImageView.image = UIImage(named: items[0].backgroundUrl)
            (cell as! ShopCouponTableViewCell).descriptionLabel.text = items[0].description
            (cell as! ShopCouponTableViewCell).categoryLabel.text = "🏷 Travel"
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = (segue.destinationViewController as! UINavigationController).visibleViewController as! CouponDetailsViewController
        
        if shopName! == "Phillips Island" {
            let couponData = CouponData(shopName: "Phillips Island", shopStreet: "1019 Ventnor Rd", shopTown: "Summerlands, Victoria 3922", validFrom: "2015-10-23", validTo: "2015-11-01", couponDesc: "Experience a real farm and interact with animals at Phillips Island. 1 day tour with lunch provided just for $87.99!", couponFinePrint: "TBA", background: "taiwan", phone: "03 5952 2200", category: "Travel")
            
            controller.couponData = couponData
        } else if shopName! == "Hot Balloon Adventure" {
            let couponData = CouponData(shopName: "Hot Balloon Adventure", shopStreet: "4 Pleasant Ave", shopTown: "North Wollongong NSW 2500", validFrom: "2015-10-01", validTo: "2015-11-28", couponDesc: "1.5 hour hot balloon tour with complimentary hot breakfast fot just $162. Offer ends 21st October!", couponFinePrint: "TBA", background: "on_hot_balloon", phone: "04 2212 1920", category: "Travel")
            
            controller.couponData = couponData
        }
    }
}

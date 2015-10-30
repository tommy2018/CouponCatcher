//
//  CouponDetailsViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 25/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit
import CoreData

class CouponDetailsViewController: UIViewController {
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var couponImageView: UIImageView!
    @IBOutlet var shopTownLabel: UILabel!
    @IBOutlet var couponFinePrintLabel: UILabel!
    @IBOutlet var shopPhoneLabel: UILabel!
    @IBOutlet var shopAddressStreetLabel: UILabel!
    @IBOutlet var couponValidDateLabel: UILabel!
    @IBOutlet var couponDescriptionLabel: UILabel!
    @IBOutlet var msgLabel: UILabel!
    @IBOutlet var msgImageView: UIImageView!
    @IBOutlet var msgView: UIView!
    @IBOutlet var shopName: UILabel!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var actionButton: UIBarButtonItem!
    let imageURL = "http://10.64.169.231/images/"
    
    let errorMsg = "Unable to load the coupon"
    var coupon: Coupon?
    var couponData: CouponData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if coupon != nil {
            displayCoupon(coupon!)
            self.navigationItem.rightBarButtonItem?.title = "Use"
        } else if couponData != nil {
            displayCoupon(couponData!)
            self.navigationItem.rightBarButtonItem?.title = "Save"
        } else {
            self.errorHandler()
        }
    }
    
    func displayCoupon(data: Coupon) {
        let image = UIImage(named: data.background!)
        
        couponImageView.image = image
        shopTownLabel.text = data.shopTown
        shopPhoneLabel.text = data.phone
        couponDescriptionLabel.text = data.desc
        couponFinePrintLabel.text = data.finePrint
        shopAddressStreetLabel.text = data.shopStreet
        shopName.text = data.shopName
        couponValidDateLabel.text = "\(data.validFrom!) to \(data.validTo!)"
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        
        dispatch_async(backgroundQueue, {
            if let url = NSURL(string: "\(self.imageURL)\(data.background)") {
                let imageData = NSData(contentsOfURL: url)
                
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.backgroundImageView.image = image
                        self.couponImageView.image = image
                    })
                }
            }
        })
    }
    
    func displayCoupon(data: CouponData) {
        let image = UIImage(named: data.background)
        
        couponImageView.image = image
        shopTownLabel.text = data.shopTown
        shopPhoneLabel.text = data.phone
        couponDescriptionLabel.text = data.couponDesc
        couponFinePrintLabel.text = data.couponFinePrint
        shopAddressStreetLabel.text = data.shopStreet
        shopName.text = data.shopName
        couponValidDateLabel.text = "\(data.validFrom) to \(data.validTo)"
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        
        dispatch_async(backgroundQueue, {
            if let url = NSURL(string: "http://10.64.169.231/images/\(data.bg)") {
                let imageData = NSData(contentsOfURL: url)
                
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.backgroundImageView.image = image
                        self.couponImageView.image = image
                    })
                }
            }
        })
        
    }
    
    func errorHandler() {
        msgView.hidden = false
        msgImageView.image = UIImage(named: "error-outline-grey")
        msgLabel.text = self.errorMsg
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        print("Back button pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        if coupon != nil {
            let alert = UIAlertController(title: "Coupon Code", message: "Coupon code: \(coupon!.code!)", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Use", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction) in
                let appDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
                let context = appDelegate.managedObjectContext
                
                self.coupon!.used = true
                
                do {
                    try context.save()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } catch {
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else if couponData != nil {
            saveCoupon()
        }
    }
    
    func saveCoupon() {
        let appDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let coupon = NSEntityDescription.insertNewObjectForEntityForName("Coupon", inManagedObjectContext: context) as! Coupon
        
        if couponData != nil {
            coupon.category = couponData!.category
            coupon.shopName = couponData!.shopName
            coupon.desc = couponData!.couponDesc
            coupon.shopStreet = couponData!.shopStreet
            coupon.shopTown = couponData!.shopTown
            coupon.validFrom = couponData!.validFrom
            coupon.validTo = couponData?.validTo
            coupon.phone = couponData!.phone
            coupon.finePrint = couponData!.couponFinePrint
            coupon.used = false
            coupon.code = couponData!.code
            coupon.shopLat = Double(couponData!.shopLat)
            coupon.shopLng = Double(couponData!.shopLng)
            coupon.background = couponData!.bg
            
            do {
                try context.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            } catch {
            
            }
        }
    }
}

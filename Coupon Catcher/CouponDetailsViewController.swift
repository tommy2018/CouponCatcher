//
//  CouponDetailsViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 25/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit
import CoreData

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
}

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
    
    let downloadingMsg = "Downloading the coupon for you. Good things always worth the wait."
    let errorMsg = "Unable to load the coupon"
    var couponID: Int?
    var coupon: Coupon?
    var couponData: CouponData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if couponID != nil {
            loadCoupon()
        } else if coupon != nil {
            displayCoupon(coupon!)
        } else if couponData != nil {
            displayCoupon(couponData!)
            self.navigationItem.rightBarButtonItem?.title = "Save"
        } else {
            self.errorHandler()
        }
    }
    
    func displayCoupon(data: Coupon) {
    }
    
    func displayCoupon(data: CouponData) {
        let image = UIImage(named: data.background)
        
        backgroundImageView.image = image
        couponImageView.image = image
        shopTownLabel.text = data.shopTown
        shopPhoneLabel.text = data.phone
        couponDescriptionLabel.text = data.couponDesc
        couponFinePrintLabel.text = data.couponFinePrint
        shopAddressStreetLabel.text = data.shopStreet
        shopName.text = data.shopName
        couponValidDateLabel.text = "\(data.validFrom) to \(data.validTo)"
    }
    
    func loadCoupon() {
        /*
        let urlSession = NSURLSession.sharedSession()
        let components = NSURLComponents(string: "http://127.0.0.1")
        let action = NSURLQueryItem(name: "do", value: "fetch-coupon")
        let id = NSURLQueryItem(name: "id", value: couponID)
        
        components?.queryItems = [action, id]
        
        msgView.hidden = false
        msgImageView.image = UIImage(named: "cloud-download-grey")
        msgLabel.text = self.downloadingMsg
        
        if components?.URL != nil {
            let task = urlSession.dataTaskWithURL(components!.URL!, completionHandler: {(data, response, error) in
            })
            
            task.resume()
        }
        */
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
        if couponID != nil {
        } else if coupon != nil {
        } else if couponData != nil {
            saveCoupon()
        }
    }
    
    func saveCoupon() {
        let appDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let coupon = NSEntityDescription.insertNewObjectForEntityForName("Coupon", inManagedObjectContext: context) as! Coupon
        
        coupon.desc = ""
        
        do {
            try context.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        } catch {
            
        }
    }
}

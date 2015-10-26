//
//  YourCouponsTableViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 26/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit
import CoreData

class YourCouponsTableViewController: UITableViewController {
    var coupons: [Coupon]?
    @IBOutlet var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        loadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if coupons != nil {
            return coupons!.count
        } else {
            return 0
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        loadData()
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discoverCell", forIndexPath: indexPath) as! DiscoverListCell
        
        if coupons![indexPath.row].background != nil {
            cell.couponImageView.image = UIImage(named: coupons![indexPath.row].background!)
        }
        cell.coupounDescLabel.text = coupons![indexPath.row].desc
        cell.shopNameLabel.text = "🏪 \(coupons![indexPath.row].shopName!)"
        cell.categoryLabel.text = "🏷 \(coupons![indexPath.row].category!)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
            let context = appDelegate.managedObjectContext
            
            context.deleteObject(coupons![indexPath.row])
            
            do {
                try context.save()
                loadData()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            } catch {
            }
        }
    }
    
    func loadData() {
        let appDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        
        let request = NSFetchRequest(entityName: "Coupon")
        let predicate = NSPredicate(format: "used == %@", NSNumber(bool: false))
        request.predicate = predicate
        
        self.coupons = (try! context.executeFetchRequest(request)) as? [Coupon]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = (segue.destinationViewController as! UINavigationController).visibleViewController as! CouponDetailsViewController
        let row = self.tableView.indexPathForSelectedRow!.row
        
        controller.coupon = coupons![row]
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        self.tableView.editing = true
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPressed")
    }
    
    func doneButtonPressed() {
        self.tableView.editing = false
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = editButton
    }
    
}

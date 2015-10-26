//
//  HistoryViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 24/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class HistoryViewController: UIViewController {
    var coupons: [Coupon]?
    
    @IBOutlet var clearHistoryBarButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        loadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        loadData()
    }
    
    @IBAction func clearHistoryBarButtonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Clear history", message: "This can't be undone, are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction) in
            
            let appDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
            let context = appDelegate.managedObjectContext
            
            if self.coupons != nil {
                for coupon in self.coupons! {
                    context.deleteObject(coupon)
                }
            }
            
            do {
                try context.save()
                self.loadData()
            } catch {
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadData() {
        let appDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context = appDelegate.managedObjectContext
        let currentPins = mapView.annotations
        let request = NSFetchRequest(entityName: "Coupon")
        let predicate = NSPredicate(format: "used == %@", NSNumber(bool: true))
        
        request.predicate = predicate
        coupons = (try! context.executeFetchRequest(request)) as? [Coupon]
        mapView.removeAnnotations(currentPins)
        
        if coupons != nil {
            for coupon in coupons! {
                let pin = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(coupon.shopLat!), longitude: CLLocationDegrees(coupon.shopLng!))
                
                pin.coordinate = coordinate
                mapView.addAnnotation(pin)
            }
        }
    }
}

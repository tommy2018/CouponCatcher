//
//  BeaconCatcher.swift
//  Coupon Catcher
//
//  Created by Tommy on 25/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class BeaconCatcher: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = BeaconCatcher()
    let locationManager = CLLocationManager()
    var region: CLBeaconRegion
    let uuid = "74278BDA-B644-4520-8F0C-720EAF059935"
    var monitoringAtBackground = false
    var monitoringAtForeground = false
    var beacons: [CLBeacon]?
    
    override init() {
        //Create beacon region
        region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid)!, identifier: "CouponCatcherBeacons")
        super.init()
        
        //Ask for location service permission
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways {
            //Notify other classes that location service is now enabled
            NSNotificationCenter.defaultCenter().postNotificationName("LocationServiceEnabled", object: nil)
        } else {
            //Notify other classes that location service is no longer available
            NSNotificationCenter.defaultCenter().postNotificationName("LocationServiceDisabled", object: nil)
            //Stop foreground monitoring
            if monitoringAtForeground {
                monitoringAtForeground = false
                locationManager.stopRangingBeaconsInRegion(region)
            }
            
            //Stop background monitoring
            if monitoringAtBackground {
                monitoringAtBackground = false
                locationManager.stopMonitoringForRegion(region)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        //Notify other classes that the beacons array of this class has been updated
        NSNotificationCenter.defaultCenter().postNotificationName("BeaconsUpdated", object: nil)
        self.beacons = beacons
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let notification = UILocalNotification()
        //Send a notification to user if: A. this app is not running and B. Beacons have been detected
        notification.alertBody = "We discove something special for you. Open the app to check that out!"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func startBackgroundMonitoring() {
        locationManager.startMonitoringForRegion(region)
        monitoringAtBackground = true
    }
    
    func startForegroundMonitoring() {
        locationManager.startRangingBeaconsInRegion(region)
        monitoringAtForeground = true
    }
}
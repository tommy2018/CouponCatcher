//
//  Coupon+CoreDataProperties.swift
//  Coupon Catcher
//
//  Created by Tommy on 26/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Coupon {

    @NSManaged var background: String?
    @NSManaged var code: String?
    @NSManaged var desc: String?
    @NSManaged var finePrint: String?
    @NSManaged var phone: String?
    @NSManaged var shopLat: NSNumber?
    @NSManaged var shopLng: NSNumber?
    @NSManaged var shopName: String?
    @NSManaged var shopStreet: String?
    @NSManaged var shopTown: String?
    @NSManaged var validFrom: String?
    @NSManaged var validTo: String?

}

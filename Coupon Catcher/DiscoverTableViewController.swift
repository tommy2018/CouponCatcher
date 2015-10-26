//
//  DiscoverTableViewController.swift
//  Coupon Catcher
//
//  Created by Tommy on 26/10/2015.
//  Copyright © 2015 Tommy. All rights reserved.
//

import UIKit

class DiscoverTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discoverCell", forIndexPath: indexPath)
        
        (cell as! DiscoverListCell).couponImageView.image = UIImage(named: "on_hot_balloon")
        (cell as! DiscoverListCell).shopNameLabel.text = "🏪 Tommy Travel"
        (cell as! DiscoverListCell).coupounDescLabel.text = "Hello, this is description. Testing nothing here is real. Oh, yes!"
        (cell as! DiscoverListCell).categoryLabel.text = "🏷 Travel"
        
        return cell
    }
}

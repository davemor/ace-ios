//
//  VenueDetailViewController.swift
//  ACE
//
//  Created by David Morrison on 21/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class VenueDetailViewController: UITableViewController {

    // the id of the venue that we are looking at.
    var venueId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the table view
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("servicesDetailPropertyCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        (cell as? VenueDetailsCell)?.setup(Venue.all[venueId!]!)

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 400
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

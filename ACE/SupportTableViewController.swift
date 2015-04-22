//
//  SupportTableViewController.swift
//  ACE
//
//  Created by David Morrison on 22/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class SupportTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Service.all.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("supportListReuseId", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        // TODO: There is an issue here about indexing into a dictionary - ID is not Index!
        cell.textLabel?.text = Service.all[indexPath.row+1]?.displayName

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showSupportDetailsSegue", sender: indexPath)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showSupportDetailsSegue" {
            if let indexPath = sender as? NSIndexPath {
                if let dest = segue.destinationViewController as? ServiceDetailViewController {
                    dest.service = Service.all[indexPath.row]
                }
            }
        }
    }


}

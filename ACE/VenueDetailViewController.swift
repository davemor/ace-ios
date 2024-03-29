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
    var venue:Venue!
    
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
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
        case 0: return 1
        case 1: return venue.meetings.count
        case 2: return venue.services.count
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("servicesDetailPropertyCell", forIndexPath: indexPath) 

            // Configure the cell...
            (cell as? VenueDetailsCell)?.setup(venue!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("servicesDetailLinkCell", forIndexPath: indexPath) 
            
                if let linkCell = cell as? LinkCell {
                    let event = venue.meetings[indexPath.row]
                    linkCell.name.text = event.displayName
                }
                
            return cell
        default:
            // TODO: revist this
            let cell = tableView.dequeueReusableCellWithIdentifier("servicesDetailLinkCell", forIndexPath: indexPath) 
            if let linkCell = cell as? LinkCell {
                let service = venue?.services[indexPath.row]
                linkCell.name.text = service?.name
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 352
        default: return 44
        }
    }
    
    // MARK: - Sections
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return venue!.displayName
        case 1: return "Events Happening at this venue"
        case 2: return "Support available at this venue"
        default: return ""
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        case 1: return venue.meetings.count > 0 ? 24 : 0
        case 2: return venue.services.count > 0 ? 24 : 0
        default: return 0
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = sender as? NSIndexPath {
            if segue.identifier == "showServiceSegue" {
                let dest = segue.destinationViewController as? ServiceDetailViewController
                dest?.service = venue?.services[indexPath.row]
            }
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // segue based on the path
        switch indexPath.section {
        case 1:
            // self.performSegueWithIdentifier("showEventSegue", sender:indexPath)
            if let destination = self.storyboard?.instantiateViewControllerWithIdentifier("MeetingDetails") as? MeetingsDetailViewController {
                self.navigationController?.pushViewController(destination, animated: true)
                if let meeting = venue?.meetings[indexPath.row] {
                    destination.meeting = meeting
                }
            }
        case 2:
            self.performSegueWithIdentifier("showServiceSegue", sender:indexPath)
        default:
            // print("I am an executable statement.")
            print("")
        }
    }
}




















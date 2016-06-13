//
//  ServiceDetailViewController.swift
//  ACE
//
//  Created by David Morrison on 22/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UITableViewController {

    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceDescription: UILabel!

    
    @IBOutlet var businessTimeLabels: [UILabel]!
    
    @IBOutlet weak var telephone: UIButton!
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var website: UIButton!
    
    var service:Service!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension

        serviceName.text = service.name
        serviceDescription.text = service.desc
        
        /*
        serviceDescriptionHeightConstraint.constant = serviceDescription.sizeThatFits(CGSizeMake(serviceDescription.frame.size.width, CGFloat.max)).height
        serviceDescription.layoutIfNeeded()
        serviceDescription.updateConstraints()
        serviceDescription.setNeedsDisplay()
        */
        
        // set the label to empty strings
        for index in 0..<businessTimeLabels.count {
            businessTimeLabels[index].text = ""
        }

        // print(service.businessTimes.count)
        
        
        for time in service.businessTimes {
            // print(time)
            
            if time.monday
            {
                businessTimeLabels[0].text! += "\(time.open.timeStr()) - \(time.close.timeStr())"
            }
            if time.tuesday
            {
                businessTimeLabels[1].text! += "\(time.open.timeStr()) - \(time.close.timeStr())"
            }
            if time.wednesday
            {
                businessTimeLabels[2].text! += "\(time.open.timeStr()) - \(time.close.timeStr())"
            }
            if time.thursday
            {
                businessTimeLabels[3].text! += "\(time.open.timeStr()) - \(time.close.timeStr())"
            }
            if time.friday
            {
                businessTimeLabels[4].text! += "\(time.open.timeStr()) - \(time.close.timeStr())"
            }
            if time.saturday
            {
                businessTimeLabels[5].text! += "\(time.open.timeStr()) - \(time.close.timeStr())"
            }
            if time.sunday
            {
                businessTimeLabels[6].text! += "\(time.open.timeStr()) - \(time.close.timeStr())"
            }
        }
        
        // for any empty label set the label to read "closed"
        for index in 0..<businessTimeLabels.count {
            if let text = businessTimeLabels[index].text where text.isEmpty {
                businessTimeLabels[index].text = "Closed"
            }
        }
        
        telephone.setTitle(service.telephone, forState: .Normal)
        email.setTitle(service.email, forState: .Normal)
        // website.setTitle(service?.website, forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // link buttons
    @IBAction func makePhoneCall(sender: UIButton) {
        // TODO: Add the code to make a phone call.
    }
    
    @IBAction func composeEmail(sender: UIButton) {
        if let url = NSURL(string: "mailto:\(service.email)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func openWebsite(sender: UIButton) {
        if let url = NSURL(string: service.website) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func showVenue(sender: AnyObject) {
        if let venue = self.service.venue {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("venueDetailViewController") as! VenueDetailViewController
            // self.presentViewController(vc, animated: true, completion: nil)
            vc.venue = venue
            navigationController?.popViewControllerAnimated(true)
            navigationController?.pushViewController(vc, animated: true )
        }
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showVenueDetails" {
            let dest = segue.destinationViewController as! VenueDetailViewController;
            dest.venue = self.service.venue
        }
    }
    */

}

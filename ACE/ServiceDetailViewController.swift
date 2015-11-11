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
        serviceDescription.sizeToFit()
        
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
        /*
        serviceDescriptionHeightConstraint.constant = serviceDescription.sizeThatFits(CGSizeMake(serviceDescription.frame.size.width, CGFloat.max)).height
        serviceDescription.layoutIfNeeded()
        serviceDescription.updateConstraints()
        serviceDescription.setNeedsDisplay()
        */

        
        for time in service.businessTimes {
            for index in 0..<businessTimeLabels.count {
                let label = businessTimeLabels[index]
                // TODO: Finish this off!
                // Hard to know what to do exactly though.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

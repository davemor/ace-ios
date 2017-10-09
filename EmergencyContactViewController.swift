//
//  EmergencyContactViewController.swift
//  ACE
//
//  Created by David Morrison on 03/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI
import Mixpanel

class EmergencyContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Model
    var contacts: Results<Contact>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // log with analytics
        Mixpanel.sharedInstance().track("Emergency Section Opened")
        
        do {
            contacts = try Realm().objects(Contact)
        } catch {
            print("Error querying contacts from Realm in EmergencyContactViewController.")
        }
        
        // set up the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // add a message when there are no emergency contacts
        if contacts.count == 0 {
            let label = UILabel(frame:CGRectMake(0, 0,
                self.tableView.bounds.size.width,
                self.tableView.bounds.size.height))
            label.text = "There are no emergency contacts yet.";
            label.textAlignment = NSTextAlignment.Center
            label.sizeToFit()
            self.tableView.backgroundView = label;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        } else {
            tableView.backgroundView = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    @IBAction func close(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    // MARK: - Handle the text message stuff
    func sendText(phoneNumber: String) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = "I'm having a bad day.  Can you call me?"
            controller.recipients = [
                phoneNumber
            ]
            controller.messageComposeDelegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - Message controller delegate
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
        switch result {
            case .Sent: showSimpleAlert("Text sent.")
            case .Failed: showSimpleAlert("Failed to send text.")
            default:
                break;
        }
    }
    
    func showSimpleAlert(message:String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .Alert)
        alert.addAction( UIAlertAction(title: "OK", style: .Default, handler: nil) )
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
        let cell = tableView.dequeueReusableCellWithIdentifier("contactReuseId") as! ContactCell
        cell.parent = self
        
        let contact = contactAtPath(indexPath)
        cell.name.text = contact.name
        cell.phone = contact.phone
        
        return cell
    }
    
    func contactAtPath(indexPath: NSIndexPath) -> Contact {
        return contacts[indexPath.row]
    }
}

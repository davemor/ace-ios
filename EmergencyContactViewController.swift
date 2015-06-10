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

class EmergencyContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Model
    let contacts = Realm().objects(Contact)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the table view
        tableView.delegate = self
        tableView.dataSource = self
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
            var controller = MFMessageComposeViewController()
            controller.body = "I'm having a bad day.  Can you call me?"
            controller.recipients = [
                phoneNumber
            ]
            controller.messageComposeDelegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - Message controller delegate
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
        switch result.value {
        case MessageComposeResultCancelled.value: break // showSimpleAlert("Text cancelled.")
        case MFMailComposeResultSaved.value:  break // showSimpleAlert("Text saved.")
        case MFMailComposeResultSent.value: showSimpleAlert("Text sent.")
        case MFMailComposeResultFailed.value: showSimpleAlert("Failed to send text.")
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

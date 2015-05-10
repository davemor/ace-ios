//
//  ContactListViewController.swift
//  ACE
//
//  Created by David Morrison on 09/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

class ContactListViewController: UITableViewController, ABPeoplePickerNavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func add(sender: AnyObject) {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        
        if picker.respondsToSelector(Selector("predicateForEnablingPerson")) {
            picker.predicateForEnablingPerson = NSPredicate(format: "%K.@count > 0", ABPersonPhoneNumbersProperty)
        }
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    
    // MARK: - People picker delegate
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecordRef!) {
        
        let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
        let firstName: ABMultiValueRef = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue() as! String
        let secondName: ABMultiValueRef = ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue() as! String
        if (ABMultiValueGetCount(phoneNumbers) > 0) {
            let index = 0 as CFIndex
            let phone = ABMultiValueCopyValueAtIndex(phoneNumbers, index).takeRetainedValue() as! String
            
            
            println("first phone for selected contact = \(phone)")
            
            // create a new contact
            let id = Contact.create("\(firstName) \(secondName)", phone: phone)
            
            // segue to the new screen
            performSegueWithIdentifier("contactDetailsSegue", sender: id)
            
        } else {
            // no phone number, show alert
            
        }
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecordRef!) -> Bool {
        peoplePickerNavigationController(peoplePicker, didSelectPerson: person)
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        return false;
    }
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
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
        return Contact.all.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("contactReuseId", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = Contact.all[indexPath.row].name

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let id = Contact.all[indexPath.row].id
        performSegueWithIdentifier("contactDetailsSegue", sender: id)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? ContactDetailsViewController {
            let id = sender as! Int
            destination.contact = Contact.find(id)
        }
    }
}

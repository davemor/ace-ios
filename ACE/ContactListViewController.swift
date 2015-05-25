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
import RealmSwift

class ContactListViewController: UITableViewController, ABPeoplePickerNavigationControllerDelegate {

    // setup realm with a notification for changes
    let contacts = Realm().objects(Contact.self)
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set realm notification block
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.tableView.reloadData()
        }
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
        
        // TODO: This is crashing when some of the fields are missing.
        // Work out how to handle this - perhaps make the second name optional and check for it's presence.
        
        let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
        let firstName: ABMultiValueRef = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue() as! String
        let secondName: ABMultiValueRef = ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue() as! String
        if (ABMultiValueGetCount(phoneNumbers) > 0) {
            let index = 0 as CFIndex
            let phone = ABMultiValueCopyValueAtIndex(phoneNumbers, index).takeRetainedValue() as! String

            let name = "\(firstName) \(secondName)"
            
            // create a new contact
            let realm = Realm()
            realm.write {
                let contact = Contact()
                contact.name = name
                contact.phone = phone
                realm.add(contact, update: true)
            }

            // segue to the new screen
            performSegueWithIdentifier("contactDetailsSegue", sender: name)
            
        } else {
            // TODO: Add Alert, no phone number, show alert
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
        return contacts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("contactReuseId", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = contacts[indexPath.row].name

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let name = contacts[indexPath.row].name
        performSegueWithIdentifier("contactDetailsSegue", sender: name)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? ContactDetailsViewController {
            let name = sender as! String
            let query = "name = '\(name)'"
            let contact = contacts.filter(query).first
            destination.contact = contact
        }
    }
}

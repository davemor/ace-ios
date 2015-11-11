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
    var contacts: Results<Contact>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try contacts = Realm().objects(Contact.self)
        } catch {
            print("Error retriving contacts from Realm in ContactListViewController.")
        }
        
        // Set realm notification block
        do {
            try notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
                self.tableView.reloadData()
            }
        } catch {
            print("Error setting Realm notification block in ContactListViewContoller.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
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
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecordRef) {
        
        // TODO: This is crashing when some of the fields are missing.
        // Work out how to handle this - perhaps make the second name optional and check for it's presence.
        
        let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
        
        
        let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as? String
        var first_name = ""
        if firstName != nil {
            first_name = firstName! as String
        }
        
        let lastName  = ABRecordCopyValue(person, kABPersonLastNameProperty)?.takeRetainedValue() as? String
        var last_name = ""
        if lastName != nil {
            last_name = lastName! as String
        }
        if (ABMultiValueGetCount(phoneNumbers) > 0) {
            let index = 0 as CFIndex
            let phone = ABMultiValueCopyValueAtIndex(phoneNumbers, index).takeRetainedValue() as? String
            var phone_number = ""
            if phone != nil {
                phone_number = phone! as String
            }

            let name = "\(first_name) \(last_name)"
            
            // create a new contact
            do {
                let realm = try Realm()
                try realm.write {
                    let contact = Contact()
                    contact.name = name
                    contact.phone = phone_number
                    realm.add(contact, update: true)
                }
            } catch {
                print("Error writting new contact to Realm in peoplePickerNavigationController.")
            }

            // segue to the new screen
            performSegueWithIdentifier("contactDetailsSegue", sender: name)
            
        } else {
            // TODO: Add Alert, no phone number, show alert
        }
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, shouldContinueAfterSelectingPerson person: ABRecordRef) -> Bool {
        peoplePickerNavigationController(peoplePicker, didSelectPerson: person)
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        return false;
    }
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController) {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("contactReuseId", forIndexPath: indexPath)

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

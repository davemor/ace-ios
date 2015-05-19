//
//  ContactDetailsViewController.swift
//  ACE
//
//  Created by David Morrison on 10/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class ContactDetailsViewController: UITableViewController {

    var contact:Contact!
    
    // MARK: Bindings
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var phoneView: UILabel!
    @IBOutlet weak var textInEmergencySwitch: UISwitch!
    @IBOutlet weak var phoneInEmergencySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // bind the viewsr
        nameView.text = contact.name
        phoneView.text = contact.phone
        textInEmergencySwitch.setOn(contact.textInEmergency, animated: false)
        phoneInEmergencySwitch.setOn(contact.phoneInEmergency, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    @IBAction func textInEmergencyToggled(sender: UISwitch) {
        // TODO: Mutate the contact
    }
    
    @IBAction func phoneInEmergency(sender: UISwitch) {
        // TODO: Mutate the contact
    }
    
    @IBAction func removeContact(sender: UIButton) {
        let realm = Realm()
        realm.write {
            realm.delete(self.contact)
        }
        navigationController?.popViewControllerAnimated(true)
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

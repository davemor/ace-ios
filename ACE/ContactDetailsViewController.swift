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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // bind the views
        nameView.text = contact.name
        phoneView.text = contact.phone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func remove(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Confirm", message: "Remove this contact?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            let realm = Realm()
            realm.write {
                realm.delete(self.contact)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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

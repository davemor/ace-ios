//
//  AddTextEntryViewController.swift
//  ACE
//
//  Created by David Morrison on 31/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class AddTextEntryViewController: UIViewController {

    @IBOutlet weak var textEntry: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textEntry.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func close(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func add(sender: UIButton) {
        let realm = Realm()
        realm.write {
            let entry = TextDiaryEntry()
            entry.text = self.textEntry.text
            entry.myDate = NSDate() // i.e. now
            realm.add(entry, update: false)
        }
        
        let alertController = UIAlertController(title: "Added", message: "Added new text entry to diary", preferredStyle: .Alert)
        alertController.addAction( UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        }))
        self.presentViewController(alertController, animated: true) {}
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  DiaryTextEntryDetailsViewController.swift
//  ACE
//
//  Created by David Morrison on 01/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryTextEntryDetailsViewController: UIViewController {

    // MARK: - Model
    var textDiaryEntry: TextDiaryEntry!
    
    var isInEditMode = false
    
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the outlets to the model
        dateLabel.text = textDiaryEntry.date.toString()
        textView.text = textDiaryEntry.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func toggleEdit(sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        if isInEditMode {
            textView.editable = true
            textView.becomeFirstResponder()
            sender.title = "Save"
        } else {
            saveUpdates()
            textView.resignFirstResponder()
            sender.title = "Edit"
        }
    }

    @IBAction func deleteEntry(sender: AnyObject) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this forever?", preferredStyle: .Alert)
        alert.addAction( UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
            self.deleteEntry()
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        }))
        alert.addAction( UIAlertAction(title: "No", style: .Default, handler: nil) )
        self.presentViewController(alert, animated: true) {}
    }
    
    // MARK: - Updates to model
    
    func saveUpdates() {
        let realm = Realm()
        realm.write {
            self.textDiaryEntry.text = self.textView.text
        }
    }
    
    func deleteEntry() {
        let realm = Realm()
        realm.write {
            realm.delete(self.textDiaryEntry)
        }
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

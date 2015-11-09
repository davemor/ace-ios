//
//  DiaryEntryDetailsViewController.swift
//  ARC
//
//  Created by David Morrison on 16/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryEntryDetailsViewController: UIViewController {

    // MARK: - Model
    var entry: DiaryEntry!
    
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var textLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = entry.date.toRelativeName()
        imageLabel.image = UIImage(contentsOfFile: entry.imagePath)
        textLabel.text = entry.text
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: Selector("editView"))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func editView()
    {
        if self.navigationItem.rightBarButtonItem!.title == "Edit"
        {
            self.navigationItem.rightBarButtonItem!.title = "Done"
            
            textLabel.editable = true
            textLabel.becomeFirstResponder()

        }
        else
        {
            self.navigationItem.rightBarButtonItem!.title = "Edit"
            textLabel.editable = false
            textLabel.resignFirstResponder()
            
            do {
                let realm = try Realm()
                try realm.write {
                    self.entry.text = self.textLabel.text
                    realm.add(self.entry, update: true)
                }
                let alert = UIAlertController(title: "Entry Updated", message: "The entry has been updated in your diary.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } catch {
                print("Error saving updated diary entry.")
            }
        }
    }
}

//
//  DiaryViewController.swift
//  ACE
//
//  Created by David Morrison on 31/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryViewController: UITableViewController {

    // MARK: - Model
    var notificationToken: NotificationToken?
    let textEntries = Realm().objects(TextDiaryEntry)
    // let imageEntries = Realm().objects(TextDiaryEntry)
    var diaryEntries = [DiaryEntry]()
    
    // MARK - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
        
        // Set realm notification block
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.refresh()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        diaryEntries.removeAll(keepCapacity: true)
        diaryEntries += Array(textEntries.generate()).map { entry in return entry as DiaryEntry }
        // TODO: Add other kinds of diary entries
        diaryEntries.sortUsing { $0.date }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func close(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func new(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: "Add an entry", preferredStyle: .ActionSheet)
        alertController.addAction( UIAlertAction(title: "Write something", style: .Default, handler: { (action) in
            self.performSegueWithIdentifier("writeSomethingSegue", sender: nil)
        }))
        alertController.addAction( UIAlertAction(title: "Add a photo", style: .Default, handler: { (action) in
            println("ADD PHOTO")
        }))
        alertController.addAction( UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
           println("CANCELLED")
        }))
        self.presentViewController(alertController, animated: true) {}
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
        return diaryEntries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCellId", forIndexPath: indexPath) as! UITableViewCell

        let entry = entryAtPath(indexPath)
        cell.textLabel!.text = entry.date.toString()

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            // TODO: Switch on the cell type
        self.performSegueWithIdentifier("textDiaryEntryDetailSegue", sender: indexPath)
    }
    
    func entryAtPath(indexPath: NSIndexPath) -> DiaryEntry {
        return diaryEntries[indexPath.row]
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "textDiaryEntryDetailSegue" {
            let entry = entryAtPath(sender as! NSIndexPath)
            let dest = segue.destinationViewController as! DiaryTextEntryDetailsViewController
            dest.textDiaryEntry = entry as! TextDiaryEntry
        }
    }

}

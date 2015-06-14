//
//  DiaryViewController.swift
//  ACE
//
//  Created by David Morrison on 31/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Model
    var notificationToken: NotificationToken?
    let diaryEntries = Realm().objects(DiaryEntry).sorted("date")

    // MARK: - Lifecycle
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
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func close(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
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
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("topCellId", forIndexPath: indexPath) as! DiaryTopCell
            
            let entry = entryAtPath(indexPath)
            cell.titleLabel.text = entry.text
            cell.dateLabel.text = entry.date.toString()
            if let image = UIImage(contentsOfFile: entry.imagePath) {
                cell.backgroundImage.image = image
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("textCellId", forIndexPath: indexPath) as! UITableViewCell
            //let entry = entryAtPath(indexPath)
            //cell.textLabel!.text = entry.date.toString()
            return cell
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry = entryAtPath(indexPath)
        self.performSegueWithIdentifier("viewEntrySegue", sender: indexPath)
    }
    
    func entryAtPath(indexPath: NSIndexPath) -> DiaryEntry {
        return diaryEntries[indexPath.row]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "newEntrySegue" {
            // don't do anything at the moment
        }
        if segue.identifier == "viewEntrySegue" {
            let entry = entryAtPath(sender as! NSIndexPath)
        }
    }
}

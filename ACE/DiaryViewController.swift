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
    var diaryEntries: Results<(DiaryEntry)>!

    var userImage: UIImage?
    
    var images: [Int:UIImage] = [Int:UIImage]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try diaryEntries = Realm().objects(DiaryEntry).sorted("date", ascending: false)
            
            // Set realm notification block
            try notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
                self.refresh()
            }
        } catch {
            print("Errors with DiaryViewController.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let filePath = defaults.objectForKey("user_picture") as? String {
            userImage = UIImage(contentsOfFile: documentPath(filePath))
        }
        var idx = 0
        for entry in diaryEntries {
            if entry.hasImage {
                images[idx] = UIImage(contentsOfFile: documentPath(entry.imagePath))
            }
            idx = idx + 1
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        refresh()
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else {
            return 200
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("topCellId", forIndexPath: indexPath) as! DiaryTopCell
            
            let entry = entryAtPath(indexPath)
            cell.titleLabel.text = entry.text.stringByAppendingString("\n\n\n\n")
            cell.dateLabel.text = entry.date.toRelativeName()
            if let image = UIImage(contentsOfFile: documentPath(entry.imagePath)) {
                cell.backgroundImage.image = image
            }
            cell.backgroundImage.layer.zPosition = -1
            if let image = userImage {
                cell.userImage.image = image
                cell.userImage.setNeedsDisplay()
            }
            cell.backgroundColor = UIColor.clearColor()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("textCellId", forIndexPath: indexPath) as! DiaryCell
            let entry = entryAtPath(indexPath)
            cell.dateLabel.text = entry.date.toRelativeName()
            cell.titleLabel.text = entry.text.stringByAppendingString("\n\n\n\n")
            if entry.hasImage {
                // print(indexPath, terminator: "")
                if let img = images[indexPath.row] {
                    cell.backgroundImage.image = img
                }
            }
            cell.backgroundColor = getAceColorForIndex(indexPath.row)

            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // let entry = entryAtPath(indexPath)
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
            if let dest = segue.destinationViewController as? DiaryEntryDetailsViewController {
               dest.entry = entry
            }
        }
    }
}

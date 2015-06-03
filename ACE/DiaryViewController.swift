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
    let textEntries = Realm().objects(TextDiaryEntry)
    let imageEntries = Realm().objects(PictureDiaryEntry)
    var diaryEntries = [DiaryEntry]()
    
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
        diaryEntries.removeAll(keepCapacity: true)
        diaryEntries += Array(textEntries.generate()).map { $0 as DiaryEntry }
        diaryEntries += Array(imageEntries.generate()).map { $0 as DiaryEntry }
        // TODO: Add other kinds of diary entries
        diaryEntries = diaryEntries.sortUsing { $0.date }.reverse()
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
            self.getPhoto()
        }))
        alertController.addAction( UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
           // println("CANCELLED")
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
        let entry = entryAtPath(indexPath)
        if entry is TextDiaryEntry {
            self.performSegueWithIdentifier("textDiaryEntryDetailSegue", sender: indexPath)
        } else if entry is PictureDiaryEntry {
            self.performSegueWithIdentifier("pictureDiaryEntryDetailSegue", sender: entry as! PictureDiaryEntry)
        }
    }
    
    func entryAtPath(indexPath: NSIndexPath) -> DiaryEntry {
        return diaryEntries[indexPath.row]
    }
    
    // MARK: Photo picking
    func getPhoto() {
        
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            var alert = UIAlertController(title: "Unsupported", message: "This device does not have a camera", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker, animated:true, completion:nil)
        }
    }
    
    func savePictureDiaryEntry(fileName:String) {
        let realm = Realm()
        realm.write {
            let newEntry = PictureDiaryEntry()
            newEntry.imagePath = fileName
            realm.add(newEntry)
            self.refresh()
            self.performSegueWithIdentifier("pictureDiaryEntryDetailSegue", sender: newEntry)
        }
    }
    
    // MARK - ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // save the image to the image library
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        // create a unique file name for the image
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss-SSS" // ms for a unique filename
        let now = NSDate()
        let dateStr = dateFormatter.stringFromDate(now)
        let randomStr = toString(arc4random_uniform(256)) // and a random number
        var imageFileName = dateStr + randomStr
        
        // save the image to our local directory so the app can get it back
        let pngData = UIImagePNGRepresentation(image);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsPath = paths[0] as! String
        imageFileName = documentsPath.stringByAppendingPathComponent(imageFileName) + ".png"
        pngData.writeToFile(imageFileName, atomically: true)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        savePictureDiaryEntry(imageFileName)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
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
        if segue.identifier == "pictureDiaryEntryDetailSegue" {
            let entry = sender as! PictureDiaryEntry
            let dest = segue.destinationViewController as! DiaryPictureEntryDetailsViewController
            dest.entry = entry
        }
    }
}

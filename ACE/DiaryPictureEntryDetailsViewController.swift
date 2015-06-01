//
//  DiaryPictureEntryDetailsViewController.swift
//  ACE
//
//  Created by David Morrison on 01/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryPictureEntryDetailsViewController: UIViewController {

    var entry: PictureDiaryEntry!
    
    // MARK: Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // populate the view
        dateLabel.text = entry.date.toString()
        imageView.image = loadImage(entry.imagePath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    func loadImage(filePath:String) -> UIImage {
        if let image = UIImage(contentsOfFile: filePath) {
            return image
        } else {
            return UIImage() // TODO: could use a default image?
        }
    }
    
    func deleteEntry() {
        let realm = Realm()
        realm.write {
            realm.delete(self.entry)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func deletePhoto(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this forever?", preferredStyle: .Alert)
        alert.addAction( UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
            self.deleteEntry()
            self.navigationController?.popViewControllerAnimated(true)
        }))
        alert.addAction( UIAlertAction(title: "No", style: .Default, handler: nil) )
        self.presentViewController(alert, animated: true) {}
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

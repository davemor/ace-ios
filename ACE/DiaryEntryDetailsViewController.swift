//
//  DiaryEntryDetailsViewController.swift
//  ARC
//
//  Created by David Morrison on 16/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryEntryDetailsViewController: UIViewController, UITextViewDelegate {

    // MARK: - Model
    var entry: DiaryEntry!
    
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var textLabel: UITextView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = entry.date.toRelativeName()
        imageLabel.image = UIImage(contentsOfFile: entry.imagePath)
        textLabel.text = entry.text
        
        textLabel.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: Selector("editView"))
        
        let leftConstraint = NSLayoutConstraint.init(item:self.contentView,
            attribute:NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute:NSLayoutAttribute.Left,
            multiplier:1.0,
            constant:0)
        
        self.view.addConstraint(leftConstraint)
        
        let rightConstraint = NSLayoutConstraint.init(item:self.contentView,
            attribute:NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute:NSLayoutAttribute.Right,
            multiplier:1.0,
            constant:0)
        
        self.view.addConstraint(rightConstraint)
        
        if imageLabel.image == nil {
            imageHeightConstraint.constant = 0
        }
        textLabel.text = entry.text
        textHeightConstraint.constant = textLabel.sizeThatFits(CGSizeMake(textLabel.frame.size.width, 1000.0)).height
        textLabel.layoutIfNeeded()
        textLabel.updateConstraints()
        textLabel.setNeedsDisplay()
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
            scrollView.contentOffset = textLabel.frame.origin
        }
        else
        {
            self.navigationItem.rightBarButtonItem!.title = "Edit"
            textLabel.editable = false
            textLabel.resignFirstResponder()
            scrollView.contentOffset = CGPointMake(0,0);

            
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

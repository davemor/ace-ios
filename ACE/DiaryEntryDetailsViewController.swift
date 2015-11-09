//
//  DiaryEntryDetailsViewController.swift
//  ARC
//
//  Created by David Morrison on 16/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

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

}

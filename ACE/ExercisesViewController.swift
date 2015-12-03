//
//  ExercisesViewController.swift
//  ACE
//
//  Created by David Morrison on 23/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ExercisesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return Exercise.all.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell", forIndexPath: indexPath) as! ExerciseCell

        // Configure the cell...
        cell.name.text = Exercise.all[indexPath.row].title

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // self.performSegueWithIdentifier("showExerciseSteps", sender: indexPath)
        
        let filename = Exercise.all[indexPath.row].audioFile
        let urlpath = NSBundle.mainBundle().pathForResource(filename, ofType: "mp3")
        if let url:NSURL = NSURL.fileURLWithPath(urlpath!) {
            let player = AVPlayer(URL: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.presentViewController(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        } else {
            print("Could not load audio file: \(filename)")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        /*
        if segue.identifier == "showExerciseSteps" {
            if let path = sender as? NSIndexPath {
                if let dest = segue.destinationViewController as? ExerciseDetailViewController {
                    dest.exercise = Exercise.all[path.row]
                }
            }
        }
        */
    }
}
